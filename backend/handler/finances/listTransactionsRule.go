package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetAllTransactionRulesHandler
// @BasePath /api/v1
// @Summary Get all transactions
// @Description Get all transactions
// @Tags Finances
// @Accept json
// @Produce json
// @Success 200 {object} ResponseData[]
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transactions [GET]
func GetAllTransactionRulesHandler(ctx *gin.Context) {
	var transactionResponse []ResponseData

	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	query := db.Where("user_id = ?", userID).Model(&finances.TransactionRule{})

	if err := query.Scan(&transactionResponse).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, transactionResponse)
}
