package task

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"net/http"
)

// UpdateTaskStatusHandler
// @BasePath /api/v1
// @Summary Update task status
// @Description Update task status
// @Tags Task
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseTask
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /task [PUT]
func UpdateTaskStatusHandler(ctx *gin.Context) {
	id := ctx.Query("id")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	task := &schemas.Task{}

	if err := db.First(&task, id).Error; err != nil {
		helper.SendError(ctx, http.StatusNotFound, fmt.Sprintf("task status with id %s not found", id))
		return
	}

	task.Done = !task.Done

	if err := db.Save(&task).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
	}

	helper.SendSuccess(ctx, "update-task-status", ConvertTaskToResponseDataWeekTask(task))
}
