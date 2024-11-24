package shop

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// CreateItemHistoryHandler
// @BasePath /api/v1
// @Summary Create item history
// @Description Create a new item history
// @Tags Shop
// @Accept json
// @Produce json
// @Param request body CreateItemHistoryRequest true "Request body"
// @Success 200 {object} ResponseItem
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/item/history [POST]
func CreateItemHistoryHandler(ctx *gin.Context) {
	request := CreateItemHistoryRequest{}
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

	var item shop.Item
	var user schemas.User
	if err := db.Where("id = ? ", request.ItemID).First(&item).Error; err == nil {
		if err = db.Where("id = ? ", request.UserID).First(&item).Error; err == nil {
			itemHistory := shop.ItemHistory{
				User:     user,
				Item:     item,
				Date:     request.Date,
				Quantity: request.Quantity,
				Value:    request.Value,
				Done:     false,
			}

			if err = db.Create(&itemHistory).Error; err != nil {
				logger.ErrF("Error in CreateItemHistoryHandler: %s", err.Error())
				helper.SendError(ctx, http.StatusInternalServerError, err.Error())
				return
			}

			helper.SendSuccess(ctx, ConvertItemHistoryToResponse(&itemHistory))
		} else {
			logger.ErrF("Error checking user existence: %s", err.Error())
			helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
			return
		}
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking item existence: %s", err.Error())
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}
}
