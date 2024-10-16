package schemas

import (
	"github.com/golang-jwt/jwt/v5"
)

type Token struct {
	UserID uint   `json:"userId"`
	Name   string `json:"name"`
	Email  string `json:"email"`
	jwt.RegisteredClaims
}

func (t *Token) Valid() error {
	return nil
}
