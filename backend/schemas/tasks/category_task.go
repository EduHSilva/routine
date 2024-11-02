package tasks

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
)

type CategoryTask struct {
	gorm.Model
	Title  string       `gorm:"embedded;not null" json:"title"`
	Color  string       `gorm:"not null"`
	UserID uint         `gorm:"not null"`
	User   schemas.User `gorm:"foreignKey:UserID" json:"user"`
	System bool         `json:"system"`
}
