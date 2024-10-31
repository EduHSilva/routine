package home

import (
	"time"
)

type ResponseDailyData struct {
	Data    ResponseData `json:"data"`
	Message string       `json:"message"`
}

type ResponseData struct {
	Tasks []ResponseDataTasks `json:"tasks"`
	Meal  ResponseDataMeal    `json:"meal"`
}

type ResponseDataMeal struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
	Hour string `json:"hour"`
}

type ResponseSearch struct {
	Message string `json:"message"`
	Data    string `json:"data"`
}

type ResponseDataTasks struct {
	ID           uint      `json:"id"`
	CreateAt     time.Time `json:"createAt"`
	UpdateAt     time.Time `json:"updateAt"`
	DeletedAt    time.Time `json:"deletedAt,omitempty"`
	Title        string    `json:"title"`
	Frequency    string    `json:"frequency"`
	Priority     string    `json:"priority"`
	DateStart    time.Time `json:"date_start,omitempty"`
	DateEnd      time.Time `json:"date_end,omitempty"`
	StartTime    string    `json:"start_time"`
	EndTime      string    `json:"end_time"`
	CategoryName string    `json:"category"`
	Done         bool      `json:"done"`
	Color        string    `json:"color"`
}
