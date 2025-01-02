package shop

import (
	"gorm.io/gorm"
)

type Item struct {
	gorm.Model
	Title   string `gorm:"embedded;not null" json:"title"`
	GroupID uint
	Group   ItemGroup `gorm:"foreignKey:GroupID" json:"group"`
	Tag     string    `gorm:"embedded;not null" json:"tag"`
}
