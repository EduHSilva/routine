package config

import (
	"errors"
	"fmt"
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/EduHSilva/routine/schemas/health/diet"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/EduHSilva/routine/seeds"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"os"
)

func InitDatabase() (*gorm.DB, error) {
	logger = GetLogger("PG")

	var db *gorm.DB
	var err error

	env := os.Getenv("ENV")

	switch env {
	case "prod":
		db, err = initDatabase(logger)
	case "dev":
		db, err = initPGLocal(logger)
	default:
		return nil, errors.New("environment not specified or invalid")
	}

	if err != nil {
		return nil, err
	}

	tables := []interface{}{
		&schemas.User{},
		&schemas.Category{},
		&tasks.TaskRule{},
		&tasks.Task{},
		&workout.Exercise{},
		&workout.Workout{},
		&workout.ExerciseWorkout{},
		&diet.Meal{},
		&diet.Food{},
		&finances.Transaction{},
		&shop.Item{},
		&shop.ItemHistory{},
	}

	for _, table := range tables {
		if !db.Migrator().HasTable(table) {
			if err = db.AutoMigrate(table); err != nil {
				return nil, err
			}
		}
	}

	seeds.Load(db)

	return db, nil
}

func initDatabase(logger *Logger) (*gorm.DB, error) {
	host := os.Getenv("DB_HOST_PROD")
	user := os.Getenv("DB_USER_PROD")
	password := os.Getenv("DB_PASSWORD_PROD")
	dbName := os.Getenv("DB_NAME_PROD")
	port := os.Getenv("DB_PORT_PROD")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)

	db, err := gorm.Open(postgres.New(postgres.Config{
		DSN:                  dsn,
		PreferSimpleProtocol: true,
	}), &gorm.Config{})

	if err != nil {
		logger.ErrF("Postgres connection failed: %s", err)
		return nil, err
	}
	return db, nil
}

func initPGLocal(logger *Logger) (*gorm.DB, error) {
	host := os.Getenv("DB_HOST")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	port := os.Getenv("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		logger.ErrF("Postgres connection failed: %s", err)
		return nil, err
	}
	return db, nil
}
