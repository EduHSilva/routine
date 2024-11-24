package shop

import (
	"github.com/EduHSilva/routine/schemas/shop"
	"time"
)

type ResponseDataGroup struct {
	ID        uint      `json:"id"`
	CreateAt  time.Time `json:"createAt"`
	UpdateAt  time.Time `json:"updateAt"`
	DeletedAt time.Time `json:"deletedAt,omitempty"`
	Title     string    `json:"title"`
}

type ResponseData struct {
	ID        uint      `json:"id"`
	CreateAt  time.Time `json:"createAt"`
	UpdateAt  time.Time `json:"updateAt"`
	DeletedAt time.Time `json:"deletedAt,omitempty"`
	Title     string    `json:"title"`
	Quantity  int       `json:"quantity"`
	Value     float64   `json:"value"`
	Date      time.Time `json:"date"`
	Done      bool      `json:"done"`
}

type ResponseItem struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

type ResponseItems struct {
	Message string         `json:"message"`
	Data    []ResponseData `json:"data"`
}

func ConvertItemToResponse(item *shop.Item) ResponseData {
	return ResponseData{
		ID:        item.ID,
		CreateAt:  item.CreatedAt,
		UpdateAt:  item.UpdatedAt,
		DeletedAt: item.DeletedAt.Time,
		Title:     item.Title,
	}
}

func ConvertItemHistoryToResponse(item *shop.ItemHistory) ResponseData {
	return ResponseData{
		ID:        item.ID,
		CreateAt:  item.CreatedAt,
		UpdateAt:  item.UpdatedAt,
		DeletedAt: item.DeletedAt.Time,
		Title:     item.Item.Title,
		Quantity:  item.Quantity,
		Value:     item.Value,
		Date:      item.Date,
		Done:      item.Done,
	}
}

func ConvertGroupToResponse(group *shop.ItemGroup) ResponseDataGroup {
	return ResponseDataGroup{
		ID:        group.ID,
		CreateAt:  group.CreatedAt,
		UpdateAt:  group.UpdatedAt,
		DeletedAt: group.DeletedAt.Time,
		Title:     group.Title,
	}
}
