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
}

type ResponseCategory struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

type ResponseCategories struct {
	Message string         `json:"message"`
	Data    []ResponseData `json:"data"`
}

func ConvertTransactionToTransactionResponse(transaction *finances.Transaction) ResponseData {
	return ResponseData{
		ID:        transaction.ID,
		CreateAt:  transaction.CreatedAt,
		UpdateAt:  transaction.UpdatedAt,
		DeletedAt: transaction.DeletedAt.Time,
		Title:     transaction.Title,
		Income:    transaction.Income,
		Date:      transaction.Date,
		Frequency: string(transaction.Frequency),
		Category:  transaction.Category.Title,
	}
}
