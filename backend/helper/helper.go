package helper

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"net/http"
)

func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func ErrParamIsRequired(name, typ string) error {
	return fmt.Errorf("param: %s (type: %s) is required", name, typ)
}

func SendError(ctx *gin.Context, code int, msg string) {
	ctx.Header("Content-Type", "application/json; charset=utf-8")
	ctx.JSON(code, gin.H{
		"code":    code,
		"message": msg,
	})
}

func SendSuccess(ctx *gin.Context, op string, data interface{}) {
	ctx.Header("Content-Type", "application/json; charset=utf-8")

	ctx.JSON(http.StatusOK, gin.H{
		"message": fmt.Sprintf("operation from handler %s successfull", op),
		"data":    data,
	})
}

type ErrorResponse struct {
	Message string `json:"message"`
	Code    string `json:"code"`
}
