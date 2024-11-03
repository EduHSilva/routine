package seeds

import (
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"gorm.io/gorm"
)

func Load(db *gorm.DB) {
	var count int64

	db.Model(&schemas.User{}).Count(&count)
	if count == 0 {
		db.Create(&users)
	}

	db.Model(&schemas.Category{}).Count(&count)
	if count == 0 {
		db.Create(&categories)
	}

	db.Model(&workout.Exercise{}).Count(&count)
	if count == 0 {
		db.Create(loadExerciseFromFile())
	}
}
