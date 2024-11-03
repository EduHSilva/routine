package task

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// GetAllTasksRulesHandler
// @BasePath /api/v1
// @Summary Get tasks
// @Description Get all tasks user
// @Tags Task
// @Accept json
// @Produce json
// @Success 200 {object} ResponseTasks
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /tasks/rules [GET]
func GetAllTasksRulesHandler(ctx *gin.Context) {
	var tasksRules []ResponseData
	getI18n, _ := ctx.Get("i18n")

	userID, exists := ctx.Get("user_id")
	if !exists {
		helper.SendErrorDefault(ctx, http.StatusUnauthorized, getI18n.(*i18n.Localizer))
		return
	}

	if err := db.Table("task_rules").
		Select("task_rules.*, c.title AS category_name, c.color as color").
		Joins("left join categories c on c.id = task_rules.category_id").
		Where("task_rules.user_id = ? and task_rules.deleted_at is null", userID).
		Scan(&tasksRules).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	helper.SendSuccess(ctx, tasksRules)
}
