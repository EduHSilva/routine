package workout

import (
	"github.com/EduHSilva/routine/schemas/enums"
	"gorm.io/gorm"
)

type Muscle struct {
	gorm.Model
	Name  string           `json:"name"`
	Group string           `json:"group"`
	Heads enums.MuscleHead `json:"heads"`
}
