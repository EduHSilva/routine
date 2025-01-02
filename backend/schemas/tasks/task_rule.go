package tasks

import (
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/enums"
	"gorm.io/gorm"
	"time"
)

type TaskRule struct {
	gorm.Model
	Title      string
	Frequency  enums.Frequency
	Priority   enums.Priority
	DateStart  time.Time
	DateEnd    time.Time
	StartTime  string
	EndTime    string
	CategoryID uint             `gorm:"not null"`
	Category   schemas.Category `gorm:"foreignKey:CategoryID"`
	UserID     uint             `gorm:"not null"`
	User       schemas.User     `gorm:"foreignKey:UserID"`
}
