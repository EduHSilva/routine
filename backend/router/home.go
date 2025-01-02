package router

import (
	"github.com/EduHSilva/routine/handler/home"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initHomeRoutes(api *gin.RouterGroup) {
	home.InitHandler()

	api.GET("search", helper.DefaultMiddleware(), home.SearchHandler)
	api.GET("daily", helper.DefaultMiddleware(), home.GetDailyDataHandler)
}
