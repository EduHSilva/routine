package diet

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/diet"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetMealsHandler
// @BasePath /api/v1
// @Summary Get meals
// @Description Get all meals
// @Tags Diet
// @Accept json
// @Produce json
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /meals [GET]
func GetMealsHandler(ctx *gin.Context) {
	var meals []diet.Meal
	var mealResponses []ResponseData

	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Where("user_id = ?", userID).Order("name").Preload("Foods").Find(&meals).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	for _, meal := range meals {
		mealResponse := ConvertMealToResponse(&meal)
		mealResponses = append(mealResponses, mealResponse)
	}

	helper.SendSuccess(ctx, mealResponses)
}
