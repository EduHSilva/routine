package router

import (
	"github.com/EduHSilva/routine/handler/tasks"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initTaskRoutes(api *gin.RouterGroup) {
	tasks.InitHandler()

	api.POST("/task/rule", helper.DefaultMiddleware(), tasks.CreateTaskRuleHandler)
	api.DELETE("/task/rule", helper.DefaultMiddleware(), tasks.DeleteTaskRuleHandler)
	api.GET("/task/rule", helper.DefaultMiddleware(), tasks.GetTaskRuleHandler)
	api.PUT("/task/rule", helper.DefaultMiddleware(), tasks.UpdateTaskRuleHandler)

	api.GET("/tasks/rules", helper.DefaultMiddleware(), tasks.GetAllTasksRulesHandler)
	api.GET("/tasks/week", helper.DefaultMiddleware(), tasks.GetWeekTasksHandler)
	api.PUT("/task", helper.DefaultMiddleware(), tasks.UpdateTaskStatusHandler)

}
