package tasks

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
	"time"
)

type TaskRule struct {
	gorm.Model
	Title      string
	Frequency  schemas.Frequency
	Priority   schemas.Priority
	DateStart  time.Time
	DateEnd    time.Time
	StartTime  string
	EndTime    string
	CategoryID uint         `gorm:"not null"`
	Category   CategoryTask `gorm:"foreignKey:CategoryID"`
	UserID     uint         `gorm:"not null"`
	User       schemas.User `gorm:"foreignKey:UserID"`
}
