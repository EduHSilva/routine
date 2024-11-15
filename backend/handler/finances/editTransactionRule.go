package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// UpdateTransactionRuleHandler
// @BasePath /api/v1
// @Summary Update a transaction
// @Description Update the title or value of transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Param request body UpdateTransactionRequest true "Request body"
// @Success 200 {object} ResponseCategory
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transactions [PUT]
func UpdateTransactionRuleHandler(ctx *gin.Context) {
	request := UpdateTransactionRequest{}

	getI18n, _ := ctx.Get("i18n")

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

	transactionRule := &finances.TransactionRule{}

	if err := db.First(&transactionRule, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if request.Title != "" {
		transactionRule.Title = request.Title
	}

	if request.Value != 0 {
		transactionRule.Value = request.Value
	}

	if err := db.Save(&transactionRule).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	if request.Value != 0 {
		if err := db.Model(&finances.Transaction{}).
			Where("transaction_rule_id = ? AND confirmed = false", id).
			Update("value", request.Value).Error; err != nil {
			logger.ErrF("error updating transactions: %s", err.Error())
			helper.SendError(ctx, http.StatusInternalServerError, err.Error())
			return
		}
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(transactionRule))
}
