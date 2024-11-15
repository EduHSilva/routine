package finances

import (
	"gorm.io/gorm"
	"time"
)

type Transaction struct {
	gorm.Model
	Income            bool
	Value             float64
	Date              time.Time
	Confirmed         bool
	TransactionRuleID uint
	TransactionRule   TransactionRule `gorm:"foreignKey:TransactionRuleID"`
}