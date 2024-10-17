package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/handler/user"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func initUserRoutes(router *gin.Engine) {
	user.InitHandler()
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.POST("/login", helper.Middleware(false), user.LoginHandler)
	api.POST("/user", helper.Middleware(false), user.CreateUserHandler)
	api.GET("/user", helper.DefaultMiddleware(), user.GetUserHandler)
	api.PUT("/user", helper.DefaultMiddleware(), user.UpdateUserHandler)
	api.DELETE("/user", helper.DefaultMiddleware(), user.DeleteUserHandler)
	api.GET("/users", helper.DefaultMiddleware(), user.GetAllUsersHandler)

	api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
}
