package router

import (
	"github.com/EduHSilva/routine/handler/category"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initCategoryRoutes(api *gin.RouterGroup) {
	category.InitHandler()

	api.GET("category", helper.DefaultMiddleware(), category.GetCategoryHandler)
	api.GET("categories", helper.DefaultMiddleware(), category.GetAllCategoriesHandler)
	api.DELETE("category", helper.DefaultMiddleware(), category.DeleteCategoryHandler)
	api.POST("category", helper.DefaultMiddleware(), category.CreateCategoryHandler)
	api.PUT("category", helper.DefaultMiddleware(), category.UpdateCategoryHandler)
}
