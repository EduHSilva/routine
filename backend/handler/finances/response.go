package finances

import (
	"github.com/EduHSilva/routine/schemas/finances"
	"time"
)

type ResponseData struct {
	ID        uint      `json:"id"`
	CreateAt  time.Time `json:"createAt"`
	UpdateAt  time.Time `json:"updateAt"`
	DeletedAt time.Time `json:"deletedAt,omitempty"`
	Title     string    `json:"title"`
	Income    bool      `json:"income"`
	Date      time.Time `json:"date"`
	Frequency string    `json:"frequency"`
	Category  string    `json:"category"`
	DateEnd   time.Time `json:"end_date"`
	DateStart time.Time `json:"start_date"`
	Color     string    `json:"color"`
	Value     float64   `json:"value"`
}

type ResponseCategory struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

type ResponseCategories struct {
	Message string         `json:"message"`
	Data    []ResponseData `json:"data"`
}

func ConvertTransactionToTransactionResponse(transaction *finances.TransactionRule) ResponseData {
	return ResponseData{
		ID:        transaction.ID,
		CreateAt:  transaction.CreatedAt,
		UpdateAt:  transaction.UpdatedAt,
		DeletedAt: transaction.DeletedAt.Time,
		Title:     transaction.Title,
		Income:    transaction.Income,
		Category:  transaction.Category.Title,
		DateEnd:   transaction.DateEnd,
		DateStart: transaction.DateStart,
		Frequency: string(transaction.Frequency),
		Color:     transaction.Category.Color,
		Value:     transaction.Value,
	}
}
