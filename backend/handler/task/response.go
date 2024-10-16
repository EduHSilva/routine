package task

import (
	"github.com/EduHSilva/routine/schemas"
	"time"
)

type ResponseData struct {
	ID           uint      `json:"id"`
	CreateAt     time.Time `json:"createAt"`
	UpdateAt     time.Time `json:"updateAt"`
	DeletedAt    time.Time `json:"deletedAt,omitempty"`
	Title        string    `json:"title"`
	Frequency    string    `json:"frequency"`
	Priority     string    `json:"priority"`
	DateStart    time.Time `json:"date_start,omitempty"`
	DateEnd      time.Time `json:"date_end,omitempty"`
	StartTime    string    `json:"start_time"`
	EndTime      string    `json:"end_time"`
	CategoryName string    `json:"category"`
	Done         bool      `json:"done"`
	Color        string    `json:"color"`
}

func ConvertTaskRuleToResponseData(task *schemas.TaskRule) ResponseData {
	return ResponseData{
		ID:           task.ID,
		CreateAt:     task.CreatedAt,
		UpdateAt:     task.UpdatedAt,
		DeletedAt:    task.DeletedAt.Time,
		Title:        task.Title,
		Frequency:    string(task.Frequency),
		Priority:     string(task.Priority),
		DateStart:    task.DateStart,
		DateEnd:      task.DateEnd,
		StartTime:    task.StartTime,
		EndTime:      task.EndTime,
		CategoryName: task.Category.Title,
		Done:         false,
		Color:        task.Category.Color,
	}
}

type ResponseTask struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

type ResponseTasks struct {
	Message string         `json:"message"`
	Data    []ResponseData `json:"data"`
}

type ResponseDateTasks struct {
	Tasks []ResponseDataWeekTask `json:"tasks"`
}

type ResponseDataWeekTask struct {
	ID           uint   `json:"id"`
	IDTask       uint   `json:"id_task"`
	Title        string `json:"title"`
	Priority     string `json:"priority"`
	StartTime    string `json:"start_time"`
	EndTime      string `json:"end_time"`
	CategoryName string `json:"category"`
	Done         bool   `json:"done"`
	Color        string `json:"color"`
}

func ConvertTaskToResponseDataWeekTask(task *schemas.Task) ResponseDataWeekTask {
	return ResponseDataWeekTask{
		IDTask:       task.TaskRuleID,
		ID:           task.ID,
		Title:        task.TaskRule.Title,
		Priority:     string(task.TaskRule.Priority),
		StartTime:    task.TaskRule.StartTime,
		EndTime:      task.TaskRule.EndTime,
		CategoryName: task.TaskRule.Category.Title,
		Done:         task.Done,
		Color:        task.TaskRule.Category.Color,
	}
}

type ResponseTaskMap map[string]*ResponseDateTasks
