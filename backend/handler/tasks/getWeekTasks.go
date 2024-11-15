package tasks

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
	"time"
)

// GetWeekTasksHandler
// @BasePath /api/v1
// @Summary Get tasks of week
// @Description A map that associates dates (in string format) with ResponseDateTasks.
// @Tags Task
// @Accept json
// @Produce json
// @Success 200 {object} ResponseTaskMap
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Param currentDate query string true "currentDate"
// @Router /tasks/week [GET]
func GetWeekTasksHandler(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	getI18n, _ := ctx.Get("i18n")

	if !exists {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	currentDateStr := ctx.Query("currentDate")

	currentDate, err := time.Parse(time.DateOnly, currentDateStr)
	if err != nil {
		currentDate = time.Now()
	}

	query := getTaskStatusQuery(userID.(uint), currentDate)

	var task []tasks.Task
	if err = query.Find(&task).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	taskMap := make(ResponseTaskMap)
	for _, ts := range task {
		truncatedDate := ts.Date.Truncate(24 * time.Hour).Format(time.DateOnly)

		if _, ok := taskMap[truncatedDate]; !ok {
			taskMap[truncatedDate] = &ResponseDateTasks{
				Tasks: make([]ResponseDataWeekTask, 0),
			}
		}

		taskMap[truncatedDate].Tasks = append(taskMap[truncatedDate].Tasks, ResponseDataWeekTask{
			ID:           ts.ID,
			IDTask:       ts.TaskRuleID,
			Title:        ts.TaskRule.Title,
			Priority:     string(ts.TaskRule.Priority),
			StartTime:    ts.TaskRule.StartTime,
			EndTime:      ts.TaskRule.EndTime,
			CategoryName: ts.TaskRule.Category.Title,
			Done:         ts.Done,
			Color:        ts.TaskRule.Category.Color,
		})
	}

	helper.SendSuccess(ctx, taskMap)
}

func getTaskStatusQuery(userID uint, currentDate time.Time) *gorm.DB {
	query := db.Model(&tasks.Task{})

	query = query.Select("tasks.id, task_rule_id, t.category_id, t.title, done, tasks.date, t.start_time, t.end_time, t.priority, c.title, c.color")

	query = query.Joins("INNER JOIN task_rules t ON t.id = tasks.task_rule_id")
	query = query.Joins("INNER JOIN categories c ON t.category_id = c.id")

	query = query.Where("t.user_id = ?", userID)
	query = query.Where("tasks.date between ? and ?", currentDate, currentDate.AddDate(0, 0, 7))

	query = query.Preload("TaskRule").Preload("TaskRule.Category")
	return query
}
