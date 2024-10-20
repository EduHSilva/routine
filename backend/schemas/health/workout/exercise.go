package workout

import "gorm.io/gorm"

type Exercise struct {
	gorm.Model
	Name         string           `json:"name"`
	BodyPart     string           `json:"body_part"`
	Instructions string           `json:"instructions" gorm:"size:1000"`
	Muscles      []ExerciseMuscle `json:"muscles" gorm:"foreignKey:ExerciseID"`
	Alternatives []Alternative    `json:"alternatives" gorm:"foreignKey:ExerciseID"`
	Variations   []Variation      `json:"variations" gorm:"foreignKey:ExerciseID"`
}
