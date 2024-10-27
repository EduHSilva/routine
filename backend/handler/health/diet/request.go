package diet

import (
	"github.com/EduHSilva/routine/helper"
)

type CreateMealRequest struct {
	Name   string        `json:"name"`
	UserID uint          `json:"user_id"`
	Foods  []FoodRequest `json:"foods"`
}

type FoodRequest struct {
	FoodID      uint   `json:"food_id"`
	Quantity    int    `json:"quantity"`
	Name        string `json:"name"`
	Observation string `json:"observation"`
	ImageUrl    string `json:"image_url"`
}

func (r CreateMealRequest) Validate() error {

	if r.Name == "" {
		return helper.ErrParamIsRequired("name", "string")
	}
	if r.UserID == 0 {
		return helper.ErrParamIsRequired("user_id", "uint")
	}
	if len(r.Foods) == 0 {
		return helper.ErrParamIsRequired("foods", "food")
	}

	return nil
}

type UpdateMealRequest struct {
	Name  string        `json:"name"`
	Foods []FoodRequest `json:"foods"`
}

func (r UpdateMealRequest) Validate() error {
	if r.Name == "" {
		return helper.ErrParamIsRequired("name", "string")
	}
	if len(r.Foods) == 0 {
		return helper.ErrParamIsRequired("exercises", "exercise")
	}
	return nil
}
