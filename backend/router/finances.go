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

	api.POST("finances/transaction", helper.DefaultMiddleware(), finances.CreateTransactionHandler)
	api.DELETE("finances/transaction", helper.DefaultMiddleware(), finances.DeleteTransactionHandler)
	api.PUT("finances/transaction", helper.DefaultMiddleware(), finances.UpdateTransactionHandler)
	api.GET("finances/transaction", helper.DefaultMiddleware(), finances.GetTransactionHandler)
	api.GET("finances/transactions", helper.DefaultMiddleware(), finances.GetAllTransactionsHandler)
}
