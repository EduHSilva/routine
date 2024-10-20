package task

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"time"
)

type CreateTaskRequest struct {
	Title      string    `json:"title"`
	Frequency  string    `json:"frequency"`
	Priority   string    `json:"priority"`
	DateStart  time.Time `json:"date_start"`
	DateEnd    time.Time `json:"date_end"`
	StartTime  string    `json:"start_time"`
	EndTime    string    `json:"end_time"`
	CategoryID uint      `json:"category_id"`
	UserID     uint      `json:"user_id"`
}

func (r CreateTaskRequest) Validate() error {
	if r.Title == "" && r.Frequency == "" && r.Priority == "" && r.CategoryID == 0 && r.UserID == 0 {
		return fmt.Errorf("request body is empty or malformed")
	}

	if r.Title == "" {
		return helper.ErrParamIsRequired("title", "string")
	}

	if r.Frequency == "" {
		return helper.ErrParamIsRequired("frequency", "string")
	}

	if r.Priority == "" {
		return helper.ErrParamIsRequired("priority", "string")
	}

	if r.CategoryID == 0 {
		return helper.ErrParamIsRequired("category_id", "uint")
	}

	if !isValidTimeFormat(r.StartTime) {
		return helper.ErrParamIsRequired("start_time", "string")
	}
	if !isValidTimeFormat(r.EndTime) {
		return helper.ErrParamIsRequired("end_time", "string")
	}

	return nil
}

func isValidTimeFormat(t string) bool {
	_, err := time.Parse("15:04", t)
	return err == nil
}

type UpdateTaskRequest struct {
	Title      string `json:"title"`
	Priority   string `json:"priority"`
	CategoryID uint   `json:"category_id"`
}

func (r UpdateTaskRequest) Validate() error {
	if r.Title != "" {
		return nil
	}
	if r.Priority != "" {
		return nil
	}
	if r.CategoryID != 0 {
		return nil
	}

	return fmt.Errorf("at least one param is required")
}
