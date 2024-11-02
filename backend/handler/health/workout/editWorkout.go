package workout

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// UpdateWorkoutHandler
// @BasePath /api/v1
// @Summary Update workout
// @Description Update the name and exercises of workout
// @Tags Workout
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Param request body UpdateWorkoutRequest true "Request body"
// @Success 200 {object} ResponseWorkout
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /workout [PUT]
func UpdateWorkoutHandler(ctx *gin.Context) {
	request := UpdateWorkoutRequest{}

	getI18n, _ := ctx.Get("i18n")
	locale, _ := ctx.Get("locale")

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

	work := &workout.Workout{}
	if err := db.Preload("Exercises").First(&work, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if request.Name != "" {
		work.Name = request.Name
	}

	if len(request.Exercises) != 0 {
		if err := db.Where("workout_id = ?", work.ID).Delete(&workout.ExerciseWorkout{}).Error; err != nil {
			helper.SendError(ctx, http.StatusInternalServerError, "Failed to delete associated exercises")
			return
		}

		for _, ex := range request.Exercises {
			newExercise := workout.ExerciseWorkout{
				WorkoutID:   work.ID,
				ExerciseID:  ex.ExerciseID,
				Series:      ex.Series,
				Load:        ex.Load,
				RestSeconds: ex.RestSeconds,
				Repetitions: ex.Repetitions,
			}
			if err := db.Create(&newExercise).Error; err != nil {
				logger.ErrF("error updating exercises: %s", err.Error())
				helper.SendError(ctx, http.StatusInternalServerError, err.Error())
				return
			}
		}
	}

	if err := db.Save(&work).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertWorkoutToWorkoutResponse(work, locale))
}
