package workout

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
)

type ExerciseMuscle struct {
	gorm.Model
	ExerciseID uint                   `json:"exercise_id"`
	MuscleID   uint                   `json:"muscle_id"`
	Muscle     Muscle                 `json:"muscle" gorm:"foreignKey:MuscleID"`
	Function   schemas.MuscleFunction `json:"function"`
}