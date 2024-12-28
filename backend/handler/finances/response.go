package finances

import (
	"github.com/EduHSilva/routine/schemas/finances"
	"time"
)

type ResponseDataMonth struct {
	Resume       Resume         `json:"resume"`
	Transactions []ResponseData `json:"transactions"`
}

type Resume struct {
	TotalExpenses     float64 `json:"total_expenses"`
	TotalIncome       float64 `json:"total_income"`
	CurrentBalance    float64 `json:"current_balance"`
	PrevTotalValue    float64 `json:"prev_total_value"`
	PrevTotalExpenses float64 `json:"prev_total_expenses"`
	PrevTotalIncome   float64 `json:"prev_total_income"`
}

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
	Confirmed bool      `json:"confirmed"`
	RuleID    uint      `json:"rule_id"`
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
