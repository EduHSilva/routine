package schemas

import (
	"gorm.io/gorm"
	"time"
)

type TaskRule struct {
	gorm.Model
	Title      string
	Frequency  Frequency
	Priority   Priority
	DateStart  time.Time
	DateEnd    time.Time
	StartTime  string
	EndTime    string
	CategoryID uint     `gorm:"not null"`
	Category   Category `gorm:"foreignKey:CategoryID"`
	UserID     uint     `gorm:"not null"`
	User       User     `gorm:"foreignKey:UserID"`
}
