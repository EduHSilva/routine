package workout

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetWorkoutHandler
// @BasePath /api/v1
// @Summary Get workout
// @Description Get one workout
// @Tags Workout
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseWorkout
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workout [GET]
func GetWorkoutHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	work := workout.Workout{}
	if err := db.Where("id = ?", id).Preload("Exercises").Preload("Exercises.Exercise").Find(&work).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertWorkoutToWorkoutResponse(&work))
}
