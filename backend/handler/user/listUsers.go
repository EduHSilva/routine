package user

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
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

	if err := db.Find(&users).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, "error getting users from database")
		return
	}

	helper.SendSuccess(ctx, "list-users", users)
}
