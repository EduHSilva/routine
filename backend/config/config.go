package config

import (
	"encoding/json"
	"fmt"
	"github.com/joho/godotenv"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"golang.org/x/text/language"
	"gorm.io/gorm"
)

var (
	db      *gorm.DB
	logger  *Logger
	bundler *i18n.Bundle
)

func Init() error {
	var err error
	err = godotenv.Load()
	if err != nil {
		return err
	}

	db, err = InitDatabase()
	if err != nil {
		return fmt.Errorf("init database failed: %v", err)
	}

	bundler = i18n.NewBundle(language.English)
	bundler.RegisterUnmarshalFunc("json", json.Unmarshal)

	bundler.MustLoadMessageFile("i18n/en.json")
	bundler.MustLoadMessageFile("i18n/pt.json")

	return nil
}

func GetDB() *gorm.DB {
	return db
}

func GetLogger(p string) *Logger {
	logger = NewLogger(p)
	return logger
}

func GetBundler() *i18n.Bundle {
	return bundler
}
