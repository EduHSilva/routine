package user

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// GetUserHandler
// @BasePath /api/v1
// @Summary Get user
// @Description Get all info of the user
// @Tags User
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseUser
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /user [GET]
func GetUserHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	user := &schemas.User{}

	if err := db.First(&user, id).Error; err != nil {
		helper.SendError(ctx, http.StatusNotFound, fmt.Sprintf("user with id %s not found", id))
		return
	}

	helper.SendSuccess(ctx, "get-user", ConvertUserToUserResponse(user))
}
