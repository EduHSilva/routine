package home

import (
	"github.com/EduHSilva/routine/config"
	"gorm.io/gorm"
)

var (
	logger *config.Logger
	db     *gorm.DB
)

func InitHandler() {
	logger = config.GetLogger("handler home")
	db = config.GetDB()
}
