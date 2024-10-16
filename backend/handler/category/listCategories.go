package category

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
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

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendError(ctx, http.StatusUnauthorized, "error getting tasks from database - user not found")
		return
	}

	if err := db.Where("user_id = ? OR system = 1", userID).Model(&schemas.Category{}).Scan(&categoryResponses).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, "error getting categories from database")
		return
	}

	helper.SendSuccess(ctx, "list-categories", categoryResponses)
}
