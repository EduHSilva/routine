package diet

import "gorm.io/gorm"

type Meal struct {
	gorm.Model
	Name   string `json:"name"`
	Hour   string `json:"hour"`
	Foods  []Food `json:"foods" gorm:"foreignKey:MealID"`
	UserID uint   `json:"user_id"`
}
