package diet

import "gorm.io/gorm"

type Food struct {
	gorm.Model
	Name        string `json:"name"`
	ImageUrl    string `json:"image_url"`
	Quantity    int    `json:"quantity"`
	Observation string `json:"observation"`
	MealID      uint   `json:"meal_id"`
}
