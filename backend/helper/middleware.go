package helper

import (
	"github.com/EduHSilva/routine/config"
	"github.com/EduHSilva/routine/schemas"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
	"os"
	"strings"
)

func DefaultMiddleware() gin.HandlerFunc {
	return Middleware(true)
}

func Middleware(auth bool) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		if auth {
			var header = ctx.GetHeader("x-access-token")
			header = strings.TrimSpace(header)

			if header == "" {
				ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing access token"})
				return
			}

			tk := &schemas.Token{}

			secret := os.Getenv("JWT_SECRET")
			_, err := jwt.ParseWithClaims(header, tk, func(token *jwt.Token) (interface{}, error) {
				return []byte(secret), nil
			})

			if err != nil {
				ctx.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
				return
			}

			ctx.Set("user_id", tk.UserID)

			ctx.Set("user", tk)
		}

		locale := ctx.GetHeader("Accept-Language")
		if locale == "" {
			locale = "en"
		}

		newI18n := i18n.NewLocalizer(config.GetBundler(), locale)

		ctx.Set("i18n", newI18n)
		ctx.Set("locale", locale)

		ctx.Next()
	}
}
