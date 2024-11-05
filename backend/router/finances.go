package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/finances"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initFinancesRoutes(router *gin.Engine) {
	finances.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.POST("finances/rule", helper.DefaultMiddleware(), finances.CreateTransactionRuleHandler)
	api.DELETE("finances/rule", helper.DefaultMiddleware(), finances.DeleteTransactionRuleHandler)
	api.PUT("finances/rule", helper.DefaultMiddleware(), finances.UpdateTransactionRuleHandler)
	api.GET("finances/rule", helper.DefaultMiddleware(), finances.GetTransactionRuleHandler)
	api.GET("finances/rules", helper.DefaultMiddleware(), finances.GetAllTransactionRulesHandler)
}
