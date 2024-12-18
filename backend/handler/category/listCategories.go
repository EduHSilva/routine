package category

import (
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

	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	queryParams := ctx.Request.URL.Query()

	categoryType := queryParams.Get("type")

	query := db.Where("(user_id = ? OR system = true)", userID).Order("title").Model(&schemas.Category{})

	if categoryType != "all" {
		query = query.Where("type = ?", categoryType)
	}

	if err := query.Scan(&categoryResponses).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, categoryResponses)
}
