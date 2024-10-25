package diet

import (
	"encoding/json"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"
)

// SearchFoodHandler
// @BasePath /api/v1
// @Summary Search food
// @Description Search food for a diet
// @Tags Diet
// @Accept json
// @Produce json
// @Param search query string true "query"
// @Success 200 {object} ResponseFood
// @Failure 400 {object} helper.ErrorResponse
// @Failure 500 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /diet/food [GET]
func SearchFoodHandler(ctx *gin.Context) {
	getI18n, _ := ctx.Get("i18n")
	queryParams := ctx.Request.URL.Query()

	response, err := callAPI(queryParams)
	if err != nil {
		log.Printf("Error calling external API: %v", err)
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}
	defer func(Body io.ReadCloser) {
		err = Body.Close()
		if err != nil {

		}
	}(response.Body)

	body, err := io.ReadAll(response.Body)
	if err != nil {
		log.Printf("Error reading response body: %v", err)
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	var tempMap map[string]interface{}
	if err = json.Unmarshal(body, &tempMap); err != nil {
		log.Printf("Error unmarshaling JSON to temp map: %v", err)
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	commonData, ok := tempMap["common"].([]interface{})
	if !ok {
		log.Printf("Error: 'common' field is not in the expected format.")
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	var foods []ResponseDataFood
	for _, item := range commonData {
		itemJSON, err1 := json.Marshal(item)
		if err1 != nil {
			log.Printf("Error marshaling item: %v", err)
			continue
		}

		var food ResponseDataFood
		if err = json.Unmarshal(itemJSON, &food); err != nil {
			log.Printf("Error unmarshaling item to ResponseDataFood: %v", err)
			continue
		}
		foods = append(foods, food)
	}

	helper.SendSuccess(ctx, foods)
}

func callAPI(queryParams url.Values) (*http.Response, error) {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	host := os.Getenv("FOOD_API_HOST")
	token := os.Getenv("FOOD_API_KEY")
	appID := os.Getenv("FOOD_APP_ID")

	apiURL := host + "?query=" + queryParams.Encode() + "&locale=pt_BR"

	req, err := http.NewRequest("GET", apiURL, nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("x-app-id", appID)
	req.Header.Set("x-app-key", token)

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}

	return resp, nil
}
