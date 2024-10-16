package category

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// UpdateCategoryHandler
// @BasePath /api/v1
// @Summary Update category
// @Description Update the title of category
// @Tags Category
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Param request body UpdateCategoryRequest true "Request body"
// @Success 200 {object} ResponseCategory
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /category [PUT]
func UpdateCategoryHandler(ctx *gin.Context) {
	request := UpdateCategoryRequest{}

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

	if request.Title != "" {
		category.Title = request.Title
	}

	if request.Color != "" {
		category.Color = request.Color
	}

	if err := db.Save(&category).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
	}

	helper.SendSuccess(ctx, "edit-category", ConvertCategoryToCategoryResponse(category))
}
