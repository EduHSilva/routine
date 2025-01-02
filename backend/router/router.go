package router

import (
	"github.com/EduHSilva/routine/docs"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"net/http"
)

func Init() {
	router := gin.Default()

	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders: []string{"Content-Type", "Authorization", "x-access-token", "Accept-Language"},
	}))

	initRoutes(router)

	err := router.Run()
	if err != nil {
		return

	}
}

func initRoutes(router *gin.Engine) {
	basePath := "/api/v1"
	docs.SwaggerInfo.BasePath = basePath
	api := router.Group(basePath)

	api.GET("/", helper.Middleware(false), func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello World",
		})
	})
	api.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))

	initUserRoutes(api)
	initCategoryRoutes(api)
	initTaskRoutes(api)
	initWorkoutRoutes(api)
	initDietRoutes(api)
	initHomeRoutes(api)
	initFinancesRoutes(api)
	initShopRoutes(api)
}
