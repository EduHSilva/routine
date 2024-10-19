package category

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetCategoryHandler
// @BasePath /api/v1
// @Summary Get category
// @Description Get one category
// @Tags Category
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseCategory
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /category [GET]
func GetCategoryHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	category := &schemas.Category{}

	if err := db.First(&category, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertCategoryToCategoryResponse(category))
}
