package seeds

import (
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/EduHSilva/routine/schemas/tasks"
	"gorm.io/gorm"
)

func Load(db *gorm.DB) {
	var count int64

	db.Model(&schemas.User{}).Count(&count)
	if count == 0 {
		db.Create(&users)
	}

	db.Model(&tasks.CategoryTask{}).Count(&count)
	if count == 0 {
		db.Create(&categoriesTask)
	}

	//fetchExercises()
	db.Model(&workout.Exercise{}).Count(&count)
	if count == 0 {
		db.Create(loadExerciseFromFile())
	}
}
