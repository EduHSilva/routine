package shop

import (
	"github.com/EduHSilva/routine/helper"
	"time"
)

type CreateItemRequest struct {
	Title string `json:"title"`
}

func (r CreateItemRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}

	return nil
}

type CreateGroupRequest struct {
	Title string `json:"title"`
}

func (r CreateGroupRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}

	return nil
}

type CreateItemHistoryRequest struct {
	Quantity int       `json:"quantity"`
	Value    float64   `json:"value"`
	Date     time.Time `json:"date"`
	Done     bool      `json:"done"`
	ItemID   uint      `json:"item_id"`
	UserID   uint      `json:"user_id"`
}

func (r CreateItemHistoryRequest) Validate() error {

	if r.ItemID == 0 {
		return helper.ErrParamIsRequired("item_id", "uint")
	}

	if r.UserID == 0 {
		return helper.ErrParamIsRequired("user_id", "uint")
	}

	return nil
}

type UpdateItemHistoryRequest struct {
	Quantity int       `json:"quantity"`
	Value    float64   `json:"value"`
	Date     time.Time `json:"date"`
	Done     bool      `json:"done"`
}

func (r UpdateItemHistoryRequest) Validate() error {

	if r.Quantity == 0 {
		return helper.ErrParamIsRequired("quantity", "uint")
	}

	if r.Value == 0 {
		return helper.ErrParamIsRequired("value", "uint")
	}

	return nil
}

type UpdateItemGroupRequest struct {
	Title string `json:"title"`
}

func (r UpdateItemGroupRequest) Validate() error {

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}

	return nil
}
