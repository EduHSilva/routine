package workout

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
)

type Muscle struct {
	gorm.Model
	Name  string             `json:"name"`
	Group string             `json:"group"`
	Heads schemas.MuscleHead `json:"heads"`
}
