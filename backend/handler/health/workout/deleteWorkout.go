package workout

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// DeleteWorkoutHandler
// @BasePath /api/v1
// @Summary Delete workout
// @Description Delete a workout
// @Tags Workout
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseWorkout
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workout [DELETE]
func DeleteWorkoutHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	getI18n, _ := ctx.Get("i18n")
	locale, _ := ctx.Get("locale")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	work := &workout.Workout{}

	if err := db.First(&work, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Delete(&work).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertWorkoutToWorkoutResponse(work, locale))
}
