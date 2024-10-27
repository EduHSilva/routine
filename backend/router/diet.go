package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/health/diet"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initDietRoutes(router *gin.Engine) {
	diet.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("diet/meal/food", helper.DefaultMiddleware(), diet.SearchFoodHandler)
	api.POST("diet/meal", helper.DefaultMiddleware(), diet.CreateMealHandler)
	api.DELETE("diet/meal", helper.DefaultMiddleware(), diet.DeleteMealHandler)
	api.PUT("diet/meal", helper.DefaultMiddleware(), diet.UpdateMealHandler)
	api.GET("diet/meal", helper.DefaultMiddleware(), diet.GetMealHandler)
	api.GET("diet/meals", helper.DefaultMiddleware(), diet.GetMealsHandler)
}
