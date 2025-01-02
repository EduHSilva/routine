package shop

import (
	"github.com/EduHSilva/routine/helper"
	"github.com/EduHSilva/routine/schemas/shop"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"net/http"
)

// SearchItemHandler
// @BasePath /api/v1
// @Summary Search item
// @Description Search items
// @Tags Shop
// @Accept json
// @Produce json
// @Param search query string true "search"
// @Success 200 {object} ResponseSearch
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /shop/search [GET]
func SearchItemHandler(ctx *gin.Context) {
	getI18n, _ := ctx.Get("i18n")

	queryParams := ctx.Request.URL.Query()

	body, err := searchItem(queryParams.Get("search"))

	if err != nil {
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
	}

	helper.SendSuccess(ctx, body)
}

func searchItem(search string) ([]shop.Item, error) {
	var items []shop.Item

	if err := db.Where("LOWER(title) LIKE ?", "%"+search+"%").Find(&items).Error; err != nil {
		return nil, err
	}

	return items, nil
}
