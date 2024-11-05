package finances

import (
	"github.com/EduHSilva/routine/schemas/enums"
	"gorm.io/gorm"
	"time"
)

type Transaction struct {
	gorm.Model
	Income            bool
	Value             float64
	Date              time.Time
	Status            enums.StatusTransaction
	TransactionRuleID uint
	TransactionRule   TransactionRule `gorm:"foreignKey:TransactionRuleID"`
}
