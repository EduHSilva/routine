package shop

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetAllPendingItemsHandler
// @BasePath /api/v1
// @Summary Get items
// @Description Get all items
// @Tags Shop
// @Accept json
// @Produce json
// @Success 200 {object} ResponseItems
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/items [GET]
func GetAllPendingItemsHandler(ctx *gin.Context) {
	var items []ResponseData

	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	query := db.Where("user_id = ? and done = false", userID).Order("title").Model(&shop.ItemHistory{})

	if err := query.Scan(&items).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, items)
}
