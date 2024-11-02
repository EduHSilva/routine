package user

import (
	"github.com/EduHSilva/routine/schemas"
	"time"
)

type ResponseData struct {
	ID        uint      `json:"id"`
	CreateAt  time.Time `json:"createAt"`
	UpdateAt  time.Time `json:"updateAt"`
	DeletedAt time.Time `json:"deletedAt,omitempty"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Password  string    `json:"password"`
	LastLogin time.Time `json:"lastLogin,omitempty"`
}

type ResponseUser struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

type ResponseUsers struct {
	Message string         `json:"message"`
	Data    []ResponseData `json:"data"`
}

type ResponseLogin struct {
	User  ResponseData `json:"user"`
	Token string       `json:"token,omitempty"`
}

func ConvertUserToUserResponse(user *schemas.User) ResponseData {
	return ResponseData{
		ID:        user.ID,
		CreateAt:  user.CreatedAt,
		UpdateAt:  user.UpdatedAt,
		DeletedAt: user.DeletedAt.Time,
		Name:      user.Name,
		Email:     user.Email,
		LastLogin: user.LastLogin,
	}
}
