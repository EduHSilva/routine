package finances

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/finances"
	"github.com/gin-gonic/gin"
	"net/http"
)

// CreateTransactionHandler
// @BasePath /api/v1
// @Summary Create transaction
// @Description Create a new transaction
// @Tags Finances
// @Accept json
// @Produce json
// @Param request body CreateTransactionRequest true "Request body"
// @Success 200 {object} ResponseData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /finances/transaction [POST]
func CreateTransactionHandler(ctx *gin.Context) {
	request := CreateTransactionRequest{}

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

	transaction := finances.Transaction{
		Title:      request.Title,
		UserID:     request.UserID,
		CategoryID: request.CategoryID,
		Income:     request.Income,
		Date:       request.Date,
		Value:      request.Value,
		Frequency:  request.Frequency,
	}

	if err := db.Create(&transaction).Error; err != nil {
		logger.ErrF("Error in CreateTransactionHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	helper.SendSuccess(ctx, ConvertTransactionToTransactionResponse(&transaction))
}
