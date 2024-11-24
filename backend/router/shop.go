package router

import (
	"github.com/EduHSilva/routine/handler/shop"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initShopRoutes(api *gin.RouterGroup) {
	shop.InitHandler()

	// items
	api.POST("shop/item", helper.DefaultMiddleware(), shop.CreateItemHandler)
	api.GET("shop/item", helper.DefaultMiddleware(), shop.GetItemHandler)
	api.GET("shop/items", helper.DefaultMiddleware(), shop.GetAllPendingItemsHandler)

	// history
	api.PUT("shop/items/history", helper.DefaultMiddleware(), shop.UpdateItemHistoryHandler)
	api.POST("shop/item/history", helper.DefaultMiddleware(), shop.CreateItemHistoryHandler)
	api.DELETE("shop/item/history", helper.DefaultMiddleware(), shop.DeleteItemHistoryHandler)

	// groups
	api.POST("shop/group", helper.DefaultMiddleware(), shop.CreateGroupHandler)
	api.DELETE("shop/group", helper.DefaultMiddleware(), shop.DeleteItemGroupHandler)
	api.PUT("shop/group", helper.DefaultMiddleware(), shop.UpdateItemGroupHandler)
}
