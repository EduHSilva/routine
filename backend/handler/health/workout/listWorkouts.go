package workout

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetWorkoutsHandler
// @BasePath /api/v1
// @Summary Get workouts
// @Description Get all workouts
// @Tags Workout
// @Accept json
// @Produce json
// @Success 200 {object} ResponseWorkout
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workouts [GET]
func GetWorkoutsHandler(ctx *gin.Context) {
	var workouts []workout.Workout
	var workoutResponses []ResponseData

	getI18n, _ := ctx.Get("i18n")
	locale, _ := ctx.Get("locale")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Where("user_id = ?", userID).Order("name").Preload("Exercises").Preload("Exercises.Exercise").Find(&workouts).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	for _, work := range workouts {
		workoutResponse := ConvertWorkoutToWorkoutResponse(&work, locale)
		workoutResponses = append(workoutResponses, workoutResponse)
	}

	helper.SendSuccess(ctx, workoutResponses)
}
