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

// CreateGroupHandler
// @BasePath /api/v1
// @Summary Create a group
// @Description Create a new group of items
// @Tags Shop
// @Accept json
// @Produce json
// @Param request body CreateGroupRequest true "Request body"
// @Success 200 {object} ResponseGroup
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/group [POST]
func CreateGroupHandler(ctx *gin.Context) {
	request := CreateGroupRequest{}
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

	var existingGroup shop.ItemGroup
	if err := db.Where("title = ?", request.Title).First(&existingGroup).Error; err == nil {
		logger.Err("Group already exists")
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

	group := shop.ItemGroup{
		Title: request.Title,
	}

	if err := db.Create(&group).Error; err != nil {
		logger.ErrF("Error in CreateCategoryHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertGroupToResponse(&group))
}
