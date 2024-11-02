package home

import (
	"fmt"
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/health/diet"
	"github.com/EduHSilva/routine/schemas/tasks"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"gorm.io/gorm"
	"net/http"
	"time"
)

// GetDailyDataHandler
// @BasePath /api/v1
// @Summary Get daily data
// @Description Info of the day with pending tasks, next meal.
// @Tags Home
// @Accept json
// @Produce json
// @Success 200 {object} ResponseDailyData
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /daily [GET]
func GetDailyDataHandler(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	getI18n, _ := ctx.Get("i18n")

	if !exists {
		helper.SendErrorDefault(ctx, http.StatusNotFound, getI18n.(*i18n.Localizer))
		return
	}

	currentDate := time.Now()

	query := getTaskStatusQuery(userID.(uint), currentDate)

	var task []tasks.Task
	if err := query.Find(&task).Error; err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	var dataTasks []ResponseDataTasks
	for _, ts := range task {
		data := ResponseDataTasks{
			ID:           ts.ID,
			Title:        ts.TaskRule.Title,
			Priority:     string(ts.TaskRule.Priority),
			StartTime:    ts.TaskRule.StartTime,
			EndTime:      ts.TaskRule.EndTime,
			CategoryName: ts.TaskRule.Category.Title,
			Done:         ts.Done,
			Color:        ts.TaskRule.Category.Color,
		}
		dataTasks = append(dataTasks, data)
	}

	meal, _ := GetClosestMeal(db, userID.(uint))
	if meal == nil {
		data := ResponseData{
			Tasks: dataTasks,
		}
		helper.SendSuccess(ctx, data)
		return
	}

	data := ResponseData{
		Tasks: dataTasks,
		Meal: ResponseDataMeal{
			ID:   meal.ID,
			Name: meal.Name,
			Hour: meal.Hour,
		},
	}

	helper.SendSuccess(ctx, data)
}

func GetClosestMeal(db *gorm.DB, userID uint) (*diet.Meal, error) {
	var meal diet.Meal
	currentTime := time.Now().Format("15:04:05")

	err := db.
		Where("user_id = ?", userID).
		Order(fmt.Sprintf("ABS(TIMEDIFF(hour, '%s'))", currentTime)).
		First(&meal).
		Error

	if err != nil {
		return nil, err
	}
	return &meal, nil
}

func getTaskStatusQuery(userID uint, currentDate time.Time) *gorm.DB {
	query := db.Model(&tasks.Task{})

	query = query.Select("tasks.id, task_rule_id, t.category_id, t.title, done, tasks.date, t.start_time, t.end_time, t.priority, c.title, c.color")

	query = query.Joins("INNER JOIN task_rules t ON t.id = tasks.task_rule_id")
	query = query.Joins("INNER JOIN category_tasks c ON t.category_id = c.id")

	query = query.Where("t.user_id = ?", userID)
	query = query.Where("tasks.done <> true")
	query = query.Where("tasks.date >= ? AND tasks.date < ?",
		currentDate.Truncate(24*time.Hour),
		currentDate.Truncate(24*time.Hour).Add(24*time.Hour))

	query = query.Preload("TaskRule").Preload("TaskRule.Category")
	return query
}
