package category

import (
	"github.com/EduHSilva/routine/config"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetAllCategoriesHandler
// @BasePath /api/v1
// @Summary Get categories
// @Description Get all categories
// @Tags Category
// @Accept json
// @Produce json
// @Success 200 {object} ResponseCategories
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /categories [GET]
func GetAllCategoriesHandler(ctx *gin.Context) {
	var categoryResponses []ResponseData

	locale, exists := ctx.Get("locale")
	if !exists {
		locale = "en"
	}

	localizer := i18n.NewLocalizer(config.GetBundler(), locale.(string))

	userID, exists := ctx.Get("user_id")
	if !exists {
		message := localizer.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "userNotFound",
		})
		helper.SendError(ctx, http.StatusUnauthorized, message)
		return
	}

	if err := db.Where("user_id = ? OR system = 1", userID).Model(&schemas.Category{}).Scan(&categoryResponses).Error; err != nil {
		message := localizer.MustLocalize(&i18n.LocalizeConfig{
			MessageID: "genericError500",
		})
		helper.SendError(ctx, http.StatusInternalServerError, message)
		return
	}

	helper.SendSuccess(ctx, "list-categories", categoryResponses)
}
