package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// ChangeTransactionStatusHandler
// @BasePath /api/v1
// @Summary Update a transaction status
// @Description Update the status of transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transactions [PUT]
func ChangeTransactionStatusHandler(ctx *gin.Context) {
	getI18n, _ := ctx.Get("i18n")

	id := ctx.Query("id")
	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	transaction := &finances.Transaction{}

	if err := db.Preload("TransactionRule.User").First(&transaction, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	transaction.Confirmed = !transaction.Confirmed

	if err := db.Save(&transaction).Error; err != nil {
		logger.ErrF("error updating transaction: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	err := helper.UpdateUserCurrentBalance(db, transaction, true)
	if err != nil {
		return
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(&transaction.TransactionRule))
}
