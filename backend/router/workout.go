package router

import (
	"github.com/EduHSilva/routine/handler/health/workout"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initWorkoutRoutes(api *gin.RouterGroup) {
	workout.InitHandler()

	api.GET("workouts", helper.DefaultMiddleware(), workout.GetWorkoutsHandler)
	api.GET("workout", helper.DefaultMiddleware(), workout.GetWorkoutHandler)
	api.POST("workout", helper.DefaultMiddleware(), workout.CreateWorkoutHandler)
	api.DELETE("workout", helper.DefaultMiddleware(), workout.DeleteWorkoutHandler)
	api.PUT("workout", helper.DefaultMiddleware(), workout.UpdateWorkoutHandler)
	api.GET("workout/exercises", helper.DefaultMiddleware(), workout.GetExercisesHandler)
}
