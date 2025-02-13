package category

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/enums"
)

type CreateCategoryRequest struct {
	Title  string             `json:"title"`
	UserID uint               `json:"user_id"`
	Color  string             `json:"color"`
	Type   enums.CategoryType `json:"type"`
}

func (r CreateCategoryRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}
	if r.Color == "" {
		return helper.ErrParamIsRequired("color", "string")
	}

	if r.UserID == 0 {
		return helper.ErrParamIsRequired("user_id", "uint")
	}

	return nil
}

type UpdateCategoryRequest struct {
	Title string `json:"title"`
	Color string `json:"color"`
}

func (r UpdateCategoryRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}
	if r.Color == "" {
		return helper.ErrParamIsRequired("color", "string")
	}

	return nil
}
