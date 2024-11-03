package finances

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
	"time"
)

type Transaction struct {
	gorm.Model
	Title      string
	Income     bool
	Value      float64
	Date       time.Time
	CategoryID uint             `gorm:"not null"`
	Category   schemas.Category `gorm:"foreignKey:CategoryID"`
	UserID     uint             `gorm:"not null"`
	User       schemas.User     `gorm:"foreignKey:UserID"`
}
