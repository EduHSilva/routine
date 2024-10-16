package user

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
)

type CreateUserRequest struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginRequest struct {
	Email    string
	Password string
}

type UpdateUserRequest struct {
	Name string `json:"name"`
}

func (r CreateUserRequest) Validate() error {
	if r.Email == "" && r.Name == "" && r.Password == "" {
		return fmt.Errorf("request body is empty or malformed")
	}

	if r.Email == "" {
		return helper.ErrParamIsRequired("email", "string")
	}

	if r.Name == "" {
		return helper.ErrParamIsRequired("name", "string")
	}

	if r.Password == "" {
		return helper.ErrParamIsRequired("password", "string")
	}

	return nil
}

func (r UpdateUserRequest) Validate() error {
	if r.Name != "" {
		return nil
	}

	return fmt.Errorf("at least one param is required")
}
