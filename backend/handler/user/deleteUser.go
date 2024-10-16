package user

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// DeleteUserHandler
// @BasePath /api/v1
// @Summary Delete user
// @Description Delete a User
// @Tags User
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseUser
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /user [DELETE]
func DeleteUserHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	user := &schemas.User{}

	if err := db.First(&user, id).Error; err != nil {
		helper.SendError(ctx, http.StatusNotFound, fmt.Sprintf("opening with id %s not found", id))
		return
	}

	if err := db.Delete(&user).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, fmt.Sprintf("error deleting user with id %s not found", id))
		return
	}

	helper.SendSuccess(ctx, "delete-opening", ConvertUserToUserResponse(user))
}
