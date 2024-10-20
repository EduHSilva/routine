package workout

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetExercisesHandler
// @BasePath /api/v1
// @Summary Get exerciser
// @Description Get all exercises
// @Tags Workout
// @Accept json
// @Produce json
// @Success 200 {object} ResponseExercises
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workout/exercises [GET]
func GetExercisesHandler(ctx *gin.Context) {
	var exercisesResponses []ResponseDataExercise

	getI18n, _ := ctx.Get("i18n")

	if err := db.Order("name").Model(&workout.Exercise{}).Scan(&exercisesResponses).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, exercisesResponses)
}
