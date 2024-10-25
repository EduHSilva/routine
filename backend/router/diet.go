package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/health/diet"
	"github.com/EduHSilva/routine/handler/health/workout"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initDietRoutes(router *gin.Engine) {
	workout.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("meal/food", helper.DefaultMiddleware(), diet.SearchFoodHandler)
	api.POST("meal", helper.DefaultMiddleware(), diet.CreateMealHandler)
	api.DELETE("meal", helper.DefaultMiddleware(), diet.DeleteMealHandler)
	api.PUT("meal", helper.DefaultMiddleware(), diet.UpdateMealHandler)
	api.GET("meal", helper.DefaultMiddleware(), diet.GetMealHandler)
	api.GET("meals", helper.DefaultMiddleware(), diet.GetMealsHandler)
}
