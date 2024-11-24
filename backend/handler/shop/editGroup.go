package shop

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// UpdateItemGroupHandler
// @BasePath /api/v1
// @Summary Update item group
// @Description Update the item group
// @Tags Shop
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Param request body UpdateItemGroupRequest true "Request body"
// @Success 200 {object} ResponseDataGroup
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/item/history [PUT]
func UpdateItemGroupHandler(ctx *gin.Context) {
	request := UpdateItemGroupRequest{}

	getI18n, _ := ctx.Get("i18n")

	if err := ctx.BindJSON(&request); err != nil {
		logger.ErrF("validation error: %v", err.Error())
		helper.SendError(ctx, http.StatusBadRequest, err.Error())
		return
	}

	if err := request.Validate(); err != nil {
		logger.ErrF("validation error: %v", err.Error())
		helper.SendError(ctx, http.StatusBadRequest, err.Error())
		return
	}

	id := ctx.Query("id")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	itemGroup := &shop.ItemGroup{}

	if err := db.First(&itemGroup, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if request.Title != "" {
		itemGroup.Title = request.Title
	}

	if err := db.Save(&itemGroup).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
	}

	helper.SendSuccess(ctx, ConvertGroupToResponse(itemGroup))
}
