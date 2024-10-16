package task

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
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

	if id == "" {
		helper.SendError(ctx, http.StatusBadRequest,
			helper.ErrParamIsRequired("id", "query param").Error())
		return
	}

	taskRule := &schemas.TaskRule{}

	if err := db.Preload("Category").First(&taskRule, id).Error; err != nil {
		helper.SendError(ctx, http.StatusNotFound, fmt.Sprintf("task with id %s not found", id))
		return
	}

	helper.SendSuccess(ctx, "get-taskRule", ConvertTaskRuleToResponseData(taskRule))
}
