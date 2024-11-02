package task

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"time"
)

// CreateTaskRuleHandler
// @BasePath /api/v1
// @Summary Create a task
// @Description Create a new task
// @Tags Task
// @Accept json
// @Produce json
// @Param request body CreateTaskRequest true "Request body"
// @Success 200 {object} ResponseTask
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /task/rule [POST]
func CreateTaskRuleHandler(ctx *gin.Context) {
	request := CreateTaskRequest{}

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

	tx := db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			logger.Err("recovered in CreateTaskHandler")
		}
	}()

	taskRule := tasks.TaskRule{
		Title:      request.Title,
		Frequency:  schemas.Frequency(request.Frequency),
		Priority:   schemas.Priority(request.Priority),
		DateStart:  request.DateStart,
		DateEnd:    request.DateEnd,
		StartTime:  request.StartTime,
		EndTime:    request.EndTime,
		CategoryID: request.CategoryID,
		UserID:     request.UserID,
	}

	if err := tx.Create(&taskRule).Error; err != nil {
		tx.Rollback()
		logger.ErrF("Error in CreateTaskHandler: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	if err := createTaskStatus(tx, taskRule); err != nil {
		tx.Rollback()
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	tx.Commit()

	helper.SendSuccess(ctx, ConvertTaskRuleToResponseData(&taskRule))
}

func createTaskStatus(tx *gorm.DB, task tasks.TaskRule) error {
	if task.DateStart.IsZero() {
		task.DateStart = time.Now()
	}

	if task.DateEnd.IsZero() {
		switch task.Frequency {
		case schemas.Daily:
			task.DateEnd = task.DateStart.AddDate(0, 3, -1)
		case schemas.Weekly:
			task.DateEnd = task.DateStart.AddDate(1, 0, -1)
		case schemas.MondayToFriday:
			task.DateEnd = task.DateStart.AddDate(0, 3, -1)
		case schemas.Monthly:
			task.DateEnd = task.DateStart.AddDate(1, 0, -1)
		case schemas.Yearly:
			task.DateEnd = task.DateStart.AddDate(2, 0, -1)
		case schemas.Unique:
		default:
			task.DateEnd = task.DateStart
		}
	}

	intervalDays := 1
	switch task.Frequency {
	case schemas.Daily:
		intervalDays = 1
	case schemas.Weekly:
		intervalDays = 7
	case schemas.Monthly:
		intervalDays = 30
	case schemas.Yearly:
		intervalDays = 365
	}

	for date := task.DateStart; date.Before(task.DateEnd) || date.Equal(task.DateEnd); date = date.AddDate(0, 0, intervalDays) {
		if task.Frequency == schemas.MondayToFriday && (date.Weekday() < time.Monday || date.Weekday() > time.Friday) {
			continue
		}

		taskStatus := tasks.Task{
			Done:       false,
			Date:       date,
			TaskRuleID: task.ID,
		}

		if err := tx.Create(&taskStatus).Error; err != nil {
			logger.ErrF("Error in createTaskStatus: %s", err.Error())
			return err
		}
	}

	return nil
}
