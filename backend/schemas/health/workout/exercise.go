package workout

import "gorm.io/gorm"

type Exercise struct {
	gorm.Model
	Name           string `json:"name"`
	NamePt         string `json:"name_pt"`
	BodyPart       string `json:"body_part"`
	Instructions   string `json:"instructions" gorm:"size:1000"`
	InstructionsPt string `json:"instructions_pt" gorm:"size:1000"`
	GifUrl         string `json:"gif_url" gorm:"size:1000"`
}
