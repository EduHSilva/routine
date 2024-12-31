package handler

import (
	"fmt"
	"github.com/EduHSilva/routine/config"
	"github.com/EduHSilva/routine/router"
	"net/http"
)

var (
	logger *config.Logger
)

func Handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World!")
}

func Main() {
	logger = config.GetLogger("main")
	err := config.Init()

	http.HandleFunc("/", Handler)

	if err != nil {
		logger.ErrF("Configuration initialization failed with error: %v", err)
		return
	}
	router.Init()
}
