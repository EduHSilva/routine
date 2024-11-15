package router

import (
	"github.com/EduHSilva/routine/handler/health/diet"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initDietRoutes(api *gin.RouterGroup) {
	diet.InitHandler()

	api.GET("meal/food", helper.DefaultMiddleware(), diet.SearchFoodHandler)
	api.POST("meal", helper.DefaultMiddleware(), diet.CreateMealHandler)
	api.DELETE("meal", helper.DefaultMiddleware(), diet.DeleteMealHandler)
	api.PUT("meal", helper.DefaultMiddleware(), diet.UpdateMealHandler)
	api.GET("meal", helper.DefaultMiddleware(), diet.GetMealHandler)
	api.GET("meals", helper.DefaultMiddleware(), diet.GetMealsHandler)
}
