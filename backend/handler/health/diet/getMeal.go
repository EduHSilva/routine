package diet

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/diet"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetMealHandler
// @BasePath /api/v1
// @Summary Get meal
// @Description Get one meal
// @Tags Diet
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /meal [GET]
func GetMealHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	meal := diet.Meal{}
	if err := db.Where("id = ?", id).Preload("Foods").Find(&meal).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertMealToResponse(&meal))
}
