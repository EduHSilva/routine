package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/home"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initHomeRoutes(router *gin.Engine) {
	home.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("search", helper.DefaultMiddleware(), home.SearchHandler)
	api.GET("daily", helper.DefaultMiddleware(), home.GetDailyDataHandler)
}
