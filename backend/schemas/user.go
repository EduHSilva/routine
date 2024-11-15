package schemas

import (
	"gorm.io/gorm"
	"time"
)

type User struct {
	gorm.Model
	Name           string    `json:"name"`
	Email          string    `gorm:"uniqueIndex" json:"email"`
	Password       string    `json:"password"`
	LastLogin      time.Time `json:"lastLogin"`
	CurrentBalance float64   `json:"current_balance"`
}
