package user

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// UpdateUserHandler
// @BasePath /api/v1
// @Summary Update user
// @Description Update user info
// @Tags User
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Param request body UpdateUserRequest true "Request body"
// @Success 200 {object} ResponseUser
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /user [PUT]
func UpdateUserHandler(ctx *gin.Context) {
	request := UpdateUserRequest{}

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

	if request.Name != "" {
		user.Name = request.Name
	}

	if err := db.Save(&user).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
	}

	helper.SendSuccess(ctx, "update-opening", ConvertUserToUserResponse(user))
}
