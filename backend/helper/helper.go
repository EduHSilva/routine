package helper

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
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

func SendErrorDefault(ctx *gin.Context, code int, getI18n *i18n.Localizer) {
	message := ""
	switch code {
	case http.StatusNotFound:
		message = getI18n.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "notFound",
		})
		break
	case http.StatusInternalServerError:
		message = getI18n.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "genericError500",
		})
	case http.StatusUnauthorized:
		message = getI18n.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "unauthorized",
		})

	}

	ctx.Header("Content-Type", "application/json; charset=utf-8")
	ctx.JSON(code, gin.H{
		"code":    code,
		"message": message,
	})
}

func SendError(ctx *gin.Context, code int, msg string) {
	ctx.Header("Content-Type", "application/json; charset=utf-8")
	ctx.JSON(code, gin.H{
		"code":    code,
		"message": msg,
	})
}

func SendSuccess(ctx *gin.Context, data interface{}) {
	ctx.Header("Content-Type", "application/json; charset=utf-8")

	ctx.JSON(http.StatusOK, gin.H{
		"message": "ok",
		"data":    data,
	})
}

type ErrorResponse struct {
	Message string `json:"message"`
	Code    string `json:"code"`
}
