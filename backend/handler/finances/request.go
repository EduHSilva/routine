package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/enums"
	"time"
)

type CreateTransactionRequest struct {
	Title      string          `json:"title"`
	Income     bool            `json:"income"`
	Value      float64         `json:"value"`
	Date       time.Time       `json:"date"`
	Frequency  enums.Frequency `json:"frequency"`
	UserID     uint            `json:"user_id"`
	CategoryID uint            `json:"category_id"`
}

func (r CreateTransactionRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}
	if r.Frequency == "" {
		return helper.ErrParamIsRequired("frequency", "string")
	}
	if r.Value == 0 {
		return helper.ErrParamIsRequired("value", "float")
	}

	if r.UserID == 0 {
		return helper.ErrParamIsRequired("user_id", "uint")
	}
	if r.CategoryID == 0 {
		return helper.ErrParamIsRequired("category_id", "uint")
	}

	return nil
}

type UpdateTransactionRequest struct {
	Title string  `json:"title"`
	Value float64 `json:"value"`
}

func (r UpdateTransactionRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}
	if r.Value == 0 {
		return helper.ErrParamIsRequired("value", "float")
	}

	return nil
}
