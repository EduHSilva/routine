package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/enums"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"time"
)

// CreateTransactionRuleHandler
// @BasePath /api/v1
// @Summary Create transaction
// @Description Create a new transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param request body CreateTransactionRuleRequest true "Request body"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/rule [POST]
func CreateTransactionRuleHandler(ctx *gin.Context) {
	request := CreateTransactionRuleRequest{}

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

	transactionRule := finances.TransactionRule{
		Title:      request.Title,
		UserID:     request.UserID,
		CategoryID: request.CategoryID,
		Income:     request.Income,
		Value:      request.Value,
		Frequency:  request.Frequency,
		DateStart:  time.Now(),
		DateEnd:    time.Now(),
	}

	if request.StartDate != nil {
		transactionRule.DateStart = *request.StartDate
	}

	if request.EndDate != nil {
		transactionRule.DateEnd = *request.EndDate
	}

	if err := db.Create(&transactionRule).Error; err != nil {
		logger.ErrF("Error in CreateTransactionHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	if err := db.Preload("Category").First(&transactionRule, transactionRule.ID).Error; err != nil {
		logger.ErrF("Error loading transaction category: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	generateTransactionDates := func(startDate, endDate time.Time, frequency enums.Frequency) []time.Time {
		var dates []time.Time
		currentDate := startDate

		for currentDate.Before(endDate) || currentDate.Equal(endDate) {
			dates = append(dates, currentDate)

			switch frequency {
			case enums.Unique:
				return []time.Time{startDate}
			case enums.Weekly:
				currentDate = currentDate.AddDate(0, 0, 7)
			case enums.Monthly:
				currentDate = currentDate.AddDate(0, 1, 0)
			case enums.Yearly:
				currentDate = currentDate.AddDate(1, 0, 0)
			default:
				logger.ErrF("Invalid frequency: %s", frequency)
				helper.SendError(ctx, http.StatusBadRequest, "Invalid frequency")
				return nil
			}
		}
		return dates
	}

	dateEnd := transactionRule.DateEnd
	if dateEnd.IsZero() {
		dateEnd = transactionRule.DateStart.AddDate(2, 0, 0)
	}

	transactionDates := generateTransactionDates(transactionRule.DateStart, dateEnd, transactionRule.Frequency)

	for _, date := range transactionDates {
		transaction := finances.Transaction{
			Income:            transactionRule.Income,
			Value:             transactionRule.Value,
			Date:              date,
			TransactionRuleID: transactionRule.ID,
			Confirmed:         transactionRule.Frequency == enums.Unique,
			Title:             transactionRule.Title,
		}

		err := db.Transaction(func(tx *gorm.DB) error {
			if err := tx.Create(&transaction).Error; err != nil {
				logger.ErrF("Error creating transaction: %s", err.Error())
				return err
			}

			if err := tx.Preload("TransactionRule.User").First(&transaction, transaction.ID).Error; err != nil {
				logger.ErrF("Error loading TransactionRule.User: %s", err.Error())
				return err
			}

			if err := helper.UpdateUserCurrentBalance(ctx, tx, &transaction, false); err != nil {
				logger.ErrF("Error updating user balance: %s", err.Error())
				return err
			}

			return nil
		})

		if err != nil {
			helper.SendError(ctx, http.StatusInternalServerError, err.Error())
			return
		}
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(&transactionRule))
}
