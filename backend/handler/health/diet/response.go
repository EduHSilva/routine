package diet

import (
	"github.com/EduHSilva/routine/schemas/health/diet"
	"time"
)

type ResponseFood struct {
	Message string           `json:"message"`
	Data    ResponseDataFood `json:"data"`
}

type ResponseDataFood struct {
	ID          uint       `json:"tag_id"`
	Name        string     `json:"food_name"`
	Quantity    int        `json:"quantity"`
	Observation string     `json:"observation"`
	Photo       PhotoField `json:"photo"`
}

type PhotoField struct {
	Thumb string `json:"thumb"`
}

type ResponseData struct {
	ID        uint               `json:"id"`
	CreateAt  time.Time          `json:"createAt"`
	UpdateAt  time.Time          `json:"updateAt"`
	DeletedAt time.Time          `json:"deletedAt,omitempty"`
	Name      string             `json:"name"`
	Hour      string             `json:"hour"`
	Foods     []ResponseDataFood `json:"foods"`
}

type ResponseDiet struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

func ConvertFoodToResponse(food *diet.Food) ResponseDataFood {
	return ResponseDataFood{
		ID:   food.ID,
		Name: food.Name,
		Photo: PhotoField{
			Thumb: food.ImageUrl,
		},
		Quantity:    food.Quantity,
		Observation: food.Observation,
	}
}

func ConvertMealToResponse(meal *diet.Meal) ResponseData {
	foodResponse := make([]ResponseDataFood, len(meal.Foods))

	for i, food := range meal.Foods {
		foodResponse[i] = ConvertFoodToResponse(&food)
	}

	return ResponseData{
		ID:        meal.ID,
		CreateAt:  meal.CreatedAt,
		UpdateAt:  meal.UpdatedAt,
		DeletedAt: meal.DeletedAt.Time,
		Name:      meal.Name,
		Foods:     foodResponse,
		Hour:      meal.Hour,
	}
}
