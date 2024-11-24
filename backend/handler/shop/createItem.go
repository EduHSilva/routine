package shop

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// CreateItemHandler
// @BasePath /api/v1
// @Summary Create item
// @Description Create a new item
// @Tags Shop
// @Accept json
// @Produce json
// @Param request body CreateItemRequest true "Request body"
// @Success 200 {object} ResponseItem
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/item [POST]
func CreateItemHandler(ctx *gin.Context) {
	request := CreateItemRequest{}
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

	var existingItem shop.Item
	if err := db.Where("title = ?", request.Title).First(&existingItem).Error; err == nil {
		logger.Err("Item already exists")
		message := getI18n.(*i18n.Localizer).MustLocalize(&i18n.LocalizeConfig{
			MessageID: "alreadyExists",
		})
		helper.SendError(ctx, http.StatusBadRequest, message)
		return
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking item existence: %s", err.Error())
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	item := shop.Item{
		Title: request.Title,
	}

	if err := db.Create(&item).Error; err != nil {
		logger.ErrF("Error in CreateCategoryHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertItemToResponse(&item))
}
