package shop

import (
	"github.com/EduHSilva/routine/schemas"
	"gorm.io/gorm"
	"time"
)

type ItemHistory struct {
	gorm.Model
	Quantity int     `gorm:"default:1" json:"quantity"`
	Value    float64 `json:"value"`
	Date     time.Time
	Done     bool         `gorm:"default:false" json:"done"`
	ItemID   uint         `gorm:"not null"`
	Item     Item         `gorm:"foreignKey:ItemID" json:"item"`
	UserID   uint         `gorm:"not null"`
	User     schemas.User `gorm:"foreignKey:UserID" json:"user"`
}
