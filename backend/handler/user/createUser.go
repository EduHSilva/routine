package user

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// CreateUserHandler
// @BasePath /api/v1
// @Summary Create user
// @Description Create a new User
// @Tags User
// @Accept json
// @Produce json
// @Param request body CreateUserRequest true "Request body"
// @Success 200 {object} ResponseUser
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Router /user [POST]
func CreateUserHandler(ctx *gin.Context) {
	request := CreateUserRequest{}
	getI18n, _ := ctx.Get("i18n")

	if err := ctx.BindJSON(&request); err != nil {
		logger.ErrF("validation error: %v", err.Error())
		helper.SendError(ctx, http.StatusBadRequest, err.Error())
		return
	}

	if err := request.Validate(); err != nil {
		logger.ErrF("validation error: %v", err.Error())
		helper.SendError(ctx, http.StatusBadRequest, err.Error())
		return
	}

	var existingUser schemas.User
	if err := db.Where("email = ?", request.Email).First(&existingUser).Error; err == nil {
		logger.Err("User already exists")
		helper.SendError(ctx, http.StatusBadRequest, "")
		return
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking user existence: %s", err.Error())
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	hash, err := helper.HashPassword(request.Password)
	if err != nil {
		logger.ErrF("hash error: %v", err.Error())
	}

	user := schemas.User{
		Name:     request.Name,
		Email:    request.Email,
		Password: hash,
	}

	if err := db.Create(&user).Error; err != nil {
		logger.ErrF("Error in CreateUserHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertUserToUserResponse(&user))
}
