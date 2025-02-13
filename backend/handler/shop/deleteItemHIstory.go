package shop

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// DeleteItemHistoryHandler
// @BasePath /api/v1
// @Summary Delete an item history
// @Description Delete an item history
// @Tags Shop
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseItem
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/item/history [DELETE]
func DeleteItemHistoryHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	itemHistory := &shop.ItemHistory{}

	if err := db.First(&itemHistory, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Delete(&itemHistory).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertItemHistoryToResponse(itemHistory))
}
