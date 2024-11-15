package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/finances"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initFinancesRoutes(router *gin.Engine) {
	finances.InitHandler()
	basePath := "/api/v1/finances"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.POST("rule", helper.DefaultMiddleware(), finances.CreateTransactionRuleHandler)
	api.DELETE("rule", helper.DefaultMiddleware(), finances.DeleteTransactionRuleHandler)
	api.PUT("rule", helper.DefaultMiddleware(), finances.UpdateTransactionRuleHandler)
	api.GET("rule", helper.DefaultMiddleware(), finances.GetTransactionRuleHandler)
	api.GET("rules", helper.DefaultMiddleware(), finances.GetAllTransactionRulesHandler)
	api.GET("", helper.DefaultMiddleware(), finances.GetMonthDataHandler)
	api.PUT("", helper.DefaultMiddleware(), finances.ChangeTransactionStatusHandler)
}
