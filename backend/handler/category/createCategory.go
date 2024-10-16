package category

import (
	"errors"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

// CreateCategoryHandler
// @BasePath /api/v1
// @Summary Create category
// @Description Create a new Category
// @Tags Category
// @Accept json
// @Produce json
// @Param request body CreateCategoryRequest true "Request body"
// @Success 200 {object} ResponseCategory
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /category [POST]
func CreateCategoryHandler(ctx *gin.Context) {
	request := CreateCategoryRequest{}
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

	var existingCategory schemas.Category
	if err := db.Where("title = ? and user_id", request.Title, request.UserID).First(&existingCategory).Error; err == nil {
		logger.Err("Category already exists")
		helper.SendError(ctx, http.StatusBadRequest, "Category already exists with the same title")
		return
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ErrF("Error checking category existence: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, "Internal server error")
		return
	}

	category := schemas.Category{
		Title:  request.Title,
		Color:  request.Color,
		UserID: request.UserID,
	}

	if err := db.Create(&category).Error; err != nil {
		logger.ErrF("Error in CreateCategoryHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, "create-category", ConvertCategoryToCategoryResponse(&category))
}
