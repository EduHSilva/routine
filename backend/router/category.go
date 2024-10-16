package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/category"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initCategoryRoutes(router *gin.Engine) {
	category.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("/category", helper.AuthMiddleware(), category.GetCategoryHandler)
	api.GET("/categories", helper.AuthMiddleware(), category.GetAllCategoriesHandler)
	api.DELETE("/category", helper.AuthMiddleware(), category.DeleteCategoryHandler)
	api.POST("/category", helper.AuthMiddleware(), category.CreateCategoryHandler)
	api.PUT("/category", helper.AuthMiddleware(), category.UpdateCategoryHandler)
}
