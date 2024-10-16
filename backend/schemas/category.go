package schemas

import (
	"gorm.io/gorm"
)

type Category struct {
	gorm.Model
	Title  string `gorm:"embedded;not null" json:"title"`
	Color  string `gorm:"not null"`
	UserID uint   `gorm:"not null"`
	User   User   `gorm:"foreignKey:UserID" json:"user"`
	System bool   `json:"system"`
}
