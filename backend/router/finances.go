package router

import (
	"github.com/EduHSilva/routine/handler/finances"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initFinancesRoutes(api *gin.RouterGroup) {
	finances.InitHandler()

	api.POST("finances/rule", helper.DefaultMiddleware(), finances.CreateTransactionRuleHandler)
	api.DELETE("finances/rule", helper.DefaultMiddleware(), finances.DeleteTransactionRuleHandler)
	api.PUT("finances/rule", helper.DefaultMiddleware(), finances.UpdateTransactionRuleHandler)
	api.GET("finances/rule", helper.DefaultMiddleware(), finances.GetTransactionRuleHandler)
	api.GET("finances/rules", helper.DefaultMiddleware(), finances.GetAllTransactionRulesHandler)
	api.GET("finances", helper.DefaultMiddleware(), finances.GetMonthDataHandler)
	api.PUT("finances", helper.DefaultMiddleware(), finances.ChangeTransactionStatusHandler)
}
