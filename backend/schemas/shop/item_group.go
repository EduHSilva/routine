package shop

import (
	"gorm.io/gorm"
)

type ItemGroup struct {
	gorm.Model
	Title string `gorm:"unique"`
}
