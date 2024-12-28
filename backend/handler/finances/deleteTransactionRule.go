package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// DeleteTransactionRuleHandler
// @BasePath /api/v1
// @Summary Delete transaction
// @Description Delete a transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transaction [DELETE]
func DeleteTransactionRuleHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	transactionRule := &finances.TransactionRule{}

	if err := db.First(&transactionRule, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Where("transaction_rule_id = ? AND confirmed = false", id).
		Delete(&finances.Transaction{}).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	if err := db.Delete(&transactionRule).Error; err != nil {
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(transactionRule))
}
