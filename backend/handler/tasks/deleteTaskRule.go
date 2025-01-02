package tasks

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
)

// DeleteTaskRuleHandler
// @BasePath /api/v1
// @Summary Delete a task
// @Description Delete a task and yours status
// @Tags Task
// @Accept json
// @Produce json
// @Success 200 {object} ResponseTask
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Param id query uint64 true "id"
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /task/rule [DELETE]
func DeleteTaskRuleHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	tx := db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			logger.Err("recovered in CreateTaskHandler")
		}
	}()

	taskRule := &tasks.TaskRule{}

	if err := db.First(&taskRule, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	if err := deleteTaskStatus(tx, id); err != nil {
		tx.Rollback()
		helper.SendError(ctx, http.StatusInternalServerError, err.Error())
		return
	}

	tx.Commit()
	tx = db.Begin()
	if err := db.Delete(&taskRule).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	tx.Commit()

	helper.SendSuccess(ctx, ConvertTaskRuleToResponseData(taskRule))
}

func deleteTaskStatus(tx *gorm.DB, id string) error {
	tx.Delete(&tasks.Task{}, "task_rule_id = ?", id)
	return nil
}
