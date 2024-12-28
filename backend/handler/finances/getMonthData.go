package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// GetMonthDataHandler
// @BasePath /api/v1
// @Summary Get all transactions of month
// @Description Get all transactions of month
// @Tags Finances
// @Accept json
// @Produce json
// @Success 200 {object} ResponseData[]
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Param month query uint64 true "month"
// @Router /finances/month [GET]
func GetMonthDataHandler(ctx *gin.Context) {
	var transactions []ResponseData
	var resume Resume

	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	month := ctx.Query("month")
	year := ctx.Query("year")

	if month == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	query := getTransactionsMonthQuery(userID.(uint), month, year)

	if err := query.Scan(&transactions).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	query = getResumeMonthQuery(userID.(uint), month, year)

	if err := query.Find(&resume).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ResponseDataMonth{
		Resume:       resume,
		Transactions: transactions,
	})
}

func getResumeMonthQuery(userID uint, month string, year string) *gorm.DB {
	query := db.Table("transactions").
		Select("SUM(CASE WHEN transactions.confirmed = false THEN transactions.value ELSE 0 END) + u.current_balance AS prev_total_value, "+
			"SUM(CASE WHEN transactions.confirmed = true AND t.income = true THEN transactions.value ELSE 0 END) AS total_income, "+
			"SUM(CASE WHEN transactions.confirmed = false AND t.income = true THEN transactions.value ELSE 0 END) AS prev_total_income, "+
			"SUM(CASE WHEN transactions.confirmed = true AND t.income = false THEN transactions.value ELSE 0 END) AS total_expenses, "+
			"SUM(CASE WHEN transactions.confirmed = false AND t.income = false THEN transactions.value ELSE 0 END) AS prev_total_expenses, "+
			"u.current_balance").
		Joins("INNER JOIN transaction_rules t ON t.id = transactions.transaction_rule_id").
		Joins("INNER JOIN categories c ON t.category_id = c.id").
		Joins("LEFT JOIN users u ON t.user_id = u.id").
		Where("u.id = ?", userID).
		Where("EXTRACT(MONTH FROM transactions.date) = ? AND EXTRACT(YEAR FROM transactions.date) = ?", month, year).
		Where("transactions.deleted_at IS NULL").
		Group("u.current_balance")
	return query
}

func getTransactionsMonthQuery(userID uint, month string, year string) *gorm.DB {
	query := db.Model(&finances.Transaction{})

	query = query.Select("transactions.id, t.id as rule_id, t.category_id, transactions.income, date, t.frequency, transactions.value, t.title, c.color, confirmed")

	query = query.Joins("INNER JOIN transaction_rules t ON t.id = transactions.transaction_rule_id")
	query = query.Joins("INNER JOIN categories c ON t.category_id = c.id")

	query = query.Where("t.user_id = ?", userID)
	query = query.Where("EXTRACT(MONTH FROM transactions.date) = ? AND EXTRACT(YEAR FROM transactions.date) = ?", month, year)
	query = query.Order("confirmed, date")

	query = query.Preload("TransactionRule").Preload("TransactionRule.Category")
	return query
}
