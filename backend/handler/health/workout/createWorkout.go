package workout

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// CreateWorkoutHandler
// @BasePath /api/v1
// @Summary Create workout
// @Description Create a new workout
// @Tags Workout
// @Accept json
// @Produce json
// @Param request body CreateWorkoutRequest true "Request body"
// @Success 200 {object} ResponseWorkout
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workout [POST]
func CreateWorkoutHandler(ctx *gin.Context) {
	request := CreateWorkoutRequest{}
	getI18n, _ := ctx.Get("i18n")

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

	var existingWorkout workout.Workout
	if err := db.Where("name = ? and user_id", request.Name, request.UserID).First(&existingWorkout).Error; err == nil {
		logger.Err("Workout already exists")
		message := getI18n.(*i18n.Localizer).MustLocalize(&i18n.LocalizeConfig{
			MessageID: "alreadyExists",
		})
		helper.SendError(ctx, http.StatusBadRequest, message)
		return
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking workout existence: %s", err.Error())
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	work := workout.Workout{
		Name:   request.Name,
		UserID: request.UserID,
	}

	for _, e := range request.Exercises {
		work.Exercises = append(work.Exercises, workout.ExerciseWorkout{
			ExerciseID:  e.ExerciseID,
			WorkoutID:   e.WorkoutID,
			Series:      e.Series,
			Load:        e.Load,
			RestSeconds: e.RestSeconds,
			Repetitions: e.Repetitions,
		})
	}

	if err := db.Create(&work).Error; err != nil {
		logger.ErrF("Error in CreateWorkoutHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertWorkoutToWorkoutResponse(&work))
}
