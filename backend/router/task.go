package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/task"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initTaskRoutes(router *gin.Engine) {
	task.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.POST("/task/rule", helper.DefaultMiddleware(), task.CreateTaskRuleHandler)
	api.DELETE("/task/rule", helper.DefaultMiddleware(), task.DeleteTaskRuleHandler)
	api.GET("/task/rule", helper.DefaultMiddleware(), task.GetTaskRuleHandler)
	api.PUT("/task/rule", helper.DefaultMiddleware(), task.UpdateTaskRuleHandler)

	api.GET("/tasks/rules", helper.DefaultMiddleware(), task.GetAllTasksRulesHandler)
	api.GET("/tasks/week", helper.DefaultMiddleware(), task.GetWeekTasksHandler)
	api.PUT("/task", helper.DefaultMiddleware(), task.UpdateTaskStatusHandler)

}
