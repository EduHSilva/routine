package shop

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetItemHandler
// @BasePath /api/v1
// @Summary Get item history
// @Description Get item history
// @Tags Shop
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseItem
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/item [GET]
func GetItemHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	item := &shop.Item{}

	if err := db.First(&item, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertItemToResponse(item))
}
