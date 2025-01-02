package router

import (
	"github.com/EduHSilva/routine/handler/user"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
)

func initUserRoutes(api *gin.RouterGroup) {
	user.InitHandler()

	api.POST("/login", helper.Middleware(false), user.LoginHandler)
	api.POST("/user", helper.Middleware(false), user.CreateUserHandler)
	api.GET("/user", helper.DefaultMiddleware(), user.GetUserHandler)
	api.PUT("/user", helper.DefaultMiddleware(), user.UpdateUserHandler)
	api.DELETE("/user", helper.DefaultMiddleware(), user.DeleteUserHandler)
	api.GET("/users", helper.DefaultMiddleware(), user.GetAllUsersHandler)
}
