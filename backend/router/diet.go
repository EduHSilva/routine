package router

import (
	"github.com/EduHSilva/routine/handler/health/diet"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initDietRoutes(api *gin.RouterGroup) {
	diet.InitHandler()

	api.GET("diet/meal/food", helper.DefaultMiddleware(), diet.SearchFoodHandler)
	api.POST("diet/meal", helper.DefaultMiddleware(), diet.CreateMealHandler)
	api.DELETE("diet/meal", helper.DefaultMiddleware(), diet.DeleteMealHandler)
	api.PUT("diet/meal", helper.DefaultMiddleware(), diet.UpdateMealHandler)
	api.GET("diet/meal", helper.DefaultMiddleware(), diet.GetMealHandler)
	api.GET("diet/meals", helper.DefaultMiddleware(), diet.GetMealsHandler)
}
