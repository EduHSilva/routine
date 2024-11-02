package user

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetAllUsersHandler
// @BasePath /api/v1
// @Summary Get users
// @Description Get all users
// @Tags User
// @Accept json
// @Produce json
// @Success 200 {object} ResponseUsers
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /user [GET]
func GetAllUsersHandler(ctx *gin.Context) {
	var users []schemas.User
	getI18n, _ := ctx.Get("i18n")

	if err := db.Find(&users).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, users)
}
