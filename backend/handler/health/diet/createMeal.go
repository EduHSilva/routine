package diet

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/diet"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// CreateMealHandler
// @BasePath /api/v1
// @Summary Create meal
// @Description Create a new meal
// @Tags Diet
// @Accept json
// @Produce json
// @Param request body CreateMealRequest true "Request body"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /meal [POST]
func CreateMealHandler(ctx *gin.Context) {
	request := CreateMealRequest{}
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

	var existingMeal diet.Meal
	if err := db.Where("name = ? and user_id", request.Name, request.UserID).First(&existingMeal).Error; err == nil {
		logger.Err("Meal already exists")
		message := getI18n.(*i18n.Localizer).MustLocalize(&i18n.LocalizeConfig{
			MessageID: "alreadyExists",
		})
		helper.SendError(ctx, http.StatusBadRequest, message)
		return
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking workout existence: %s", err.Error())
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	meal := diet.Meal{
		Name:   request.Name,
		UserID: request.UserID,
	}

	for _, food := range request.Foods {
		meal.Foods = append(meal.Foods, diet.Food{
			Name:        food.Name,
			Quantity:    food.Quantity,
			Observation: food.Observation,
			ImageUrl:    food.ImageUrl,
		})
	}

	if err := db.Create(&meal).Error; err != nil {
		logger.ErrF("Error in CreateMealHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertMealToResponse(&meal))
}
