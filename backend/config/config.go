package config

import (
	"fmt"
	"github.com/joho/godotenv"
	"gorm.io/gorm"
)

var (
	db     *gorm.DB
	logger *Logger
)

func Init() error {
	var err error
	err = godotenv.Load()
	if err != nil {
		return err
	}

	db, err = InitDatabase()
	if err != nil {
		return fmt.Errorf("init database failed: %v", err)
	}

	return nil
}

func GetDB() *gorm.DB {
	return db
}

func GetLogger(p string) *Logger {
	logger = NewLogger(p)
	return logger
}
