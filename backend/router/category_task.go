package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/tasks/category"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initCategoryTaskRoutes(router *gin.Engine) {
	category.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("tasks/category", helper.DefaultMiddleware(), category.GetCategoryHandler)
	api.GET("tasks/categories", helper.DefaultMiddleware(), category.GetAllCategoriesHandler)
	api.DELETE("tasks/category", helper.DefaultMiddleware(), category.DeleteCategoryHandler)
	api.POST("tasks/category", helper.DefaultMiddleware(), category.CreateCategoryHandler)
	api.PUT("tasks/category", helper.DefaultMiddleware(), category.UpdateCategoryHandler)
}
