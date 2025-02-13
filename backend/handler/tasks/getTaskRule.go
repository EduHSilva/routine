package tasks

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetTaskRuleHandler
// @BasePath /api/v1
// @Summary Get task
// @Description Get all info of the task
// @Tags Task
// @Accept json
// @Produce json
// @Param id query uint64 true "id"
// @Success 200 {object} ResponseTask
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /task/rule [GET]
func GetTaskRuleHandler(ctx *gin.Context) {
	id := ctx.Query("id")
	getI18n, _ := ctx.Get("i18n")

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	taskRule := &tasks.TaskRule{}

	if err := db.Preload("Category").First(&taskRule, id).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, ConvertTaskRuleToResponseData(taskRule))
}
