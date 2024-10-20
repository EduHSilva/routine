package user

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"os"
	"time"
)

// LoginHandler
// @BasePath /api/v1
// @Summary Login
// @Description Login and generate token
// @Tags User
// @Accept json
// @Produce json
// @Param request body LoginRequest true "Request body"
// @Success 200 {object} ResponseLogin
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Router /login [POST]
func LoginHandler(ctx *gin.Context) {
	loginRequest := &LoginRequest{}

	getI18n, _ := ctx.Get("i18n")

	if err := ctx.BindJSON(&loginRequest); err != nil {
		logger.ErrF("validation error: %v", err.Error())
		helper.SendError(ctx, http.StatusBadRequest, err.Error())
		return
	}

	findOne(ctx, loginRequest.Email, loginRequest.Password, getI18n.(*i18n.Localizer))
}

func findOne(ctx *gin.Context, email, password string, getI18n *i18n.Localizer) {
	user := &schemas.User{}

	if err := db.Where("Email = ?", email).First(user).Error; err != nil {
		message := getI18n.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "invalidCredentials",
		})
		helper.SendError(ctx, http.StatusBadRequest, message)
		return
	}

	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil && errors.Is(err, bcrypt.ErrMismatchedHashAndPassword) {
		message := getI18n.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "invalidCredentials",
		})
		helper.SendError(ctx, http.StatusBadRequest, message)
		return
	}

	tokenString, err := createToken(user)
	if err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n)
		return
	}

	data := &ResponseLogin{}
	data.Token = tokenString
	data.User = ConvertUserToUserResponse(user)

	helper.SendSuccess(ctx, data)
}

func createToken(user *schemas.User) (string, error) {
	expiresAt := time.Now().Add(time.Minute * 100000).Unix()

	tk := &schemas.Token{
		UserID: user.ID,
		Name:   user.Name,
		Email:  user.Email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Unix(expiresAt, 0)),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, tk)

	secret := os.Getenv("JWT_SECRET")
	tokenString, err := token.SignedString([]byte(secret))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
