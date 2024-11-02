package workout

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
)

type Workout struct {
	gorm.Model
	Name      string            `json:"name"`
	Exercises []ExerciseWorkout `json:"exercises" gorm:"foreignKey:WorkoutID"`
	UserID    uint              `gorm:"not null"`
	User      schemas.User      `gorm:"foreignKey:UserID" json:"user"`
}
