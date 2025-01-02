package finances

import (
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/enums"
	"gorm.io/gorm"
	"time"
)

type TransactionRule struct {
	gorm.Model
	Title      string
	Frequency  enums.Frequency
	Income     bool
	Value      float64
	DateStart  time.Time
	DateEnd    time.Time
	Saving     bool
	CategoryID uint             `gorm:"not null"`
	Category   schemas.Category `gorm:"foreignKey:CategoryID"`
	UserID     uint             `gorm:"not null"`
	User       schemas.User     `gorm:"foreignKey:UserID"`
}
