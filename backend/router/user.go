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

	api.POST("/login", user.LoginHandler)
	api.POST("/user", user.CreateUserHandler)
	api.GET("/user", helper.AuthMiddleware(), user.GetUserHandler)
	api.PUT("/user", helper.AuthMiddleware(), user.UpdateUserHandler)
	api.DELETE("/user", helper.AuthMiddleware(), user.DeleteUserHandler)
	api.GET("/users", helper.AuthMiddleware(), user.GetAllUsersHandler)

	api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
}
