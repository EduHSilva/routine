package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetTransactionRuleHandler
// @BasePath /api/v1
// @Summary Get a transaction
// @Description Get one transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transaction [GET]
func GetTransactionRuleHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	transaction := &finances.TransactionRule{}

	if err := db.Preload("Category").First(&transaction, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(transaction))
}
