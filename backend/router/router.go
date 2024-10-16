package router

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func Init() {
	router := gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders: []string{"Content-Type", "Authorization", "x-access-token"},
	}))

	initRoutes(router)

	err := router.Run()
	if err != nil {
		return

	}
}

func initRoutes(router *gin.Engine) {
	initUserRoutes(router)
	initCategoryRoutes(router)
	initTaskRoutes(router)
}
