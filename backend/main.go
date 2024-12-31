package main

import (
	"github.com/EduHSilva/routine/config"
	"github.com/EduHSilva/routine/router"
)

var (
	logger *config.Logger
)

func main() {
	logger = config.GetLogger("main")
	err := config.Init()

	if err != nil {
		logger.ErrF("Configuration initialization failed with error: %v", err)
		return
	}
	router.Init()
}
