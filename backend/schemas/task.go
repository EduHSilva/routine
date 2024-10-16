package schemas

import (
	"gorm.io/gorm"
	"time"
)

type Task struct {
	gorm.Model
	Done       bool `gorm:"default:false"`
	Date       time.Time
	TaskRuleID uint     `gorm:"not null"`
	TaskRule   TaskRule `gorm:"foreignKey:TaskRuleID"`
}
