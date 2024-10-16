package category

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// DeleteCategoryHandler
// @BasePath /api/v1
// @Summary Delete category
// @Description Delete a category
// @Tags Category
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseCategory
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /category [DELETE]
func DeleteCategoryHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	category := &schemas.Category{}

	if err := db.First(&category, id).Error; err != nil {
		helper.SendError(ctx, http.StatusNotFound, fmt.Sprintf("category with id %s not found", id))
		return
	}

	if err := db.Delete(&category).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, fmt.Sprintf("error deleting category with id %s not found", id))
		return
	}

	helper.SendSuccess(ctx, "delete-category", ConvertCategoryToCategoryResponse(category))
}
