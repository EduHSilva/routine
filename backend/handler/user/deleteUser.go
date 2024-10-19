package user

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
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
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	user := &schemas.User{}

	if err := db.First(&user, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Delete(&user).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertUserToUserResponse(user))
}
