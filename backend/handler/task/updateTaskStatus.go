package task

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
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
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	task := &schemas.Task{}

	if err := db.First(&task, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	task.Done = !task.Done

	if err := db.Save(&task).Error; err != nil {
		logger.ErrF("error updating: %s", err.Error())
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
	}

	helper.SendSuccess(ctx, ConvertTaskToResponseDataWeekTask(task))
}
