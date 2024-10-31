package home

import (
	"bytes"
	"encoding/json"
	"github.com/EduHSilva/routine/helper"
	"github.com/gin-gonic/gin"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"io"
	"log"
	"net/http"
	"os"
)

// SearchHandler
// @BasePath /api/v1
// @Summary Search
// @Description Get info from gpts
// @Tags Home
// @Accept json
// @Produce json
// @Param search query string true "search"
// @Success 200 {object} ResponseSearch
// @Failure 400 {object} helper.ErrorResponse
// @Failure 401 {object} helper.ErrorResponse
// @Security ApiKeyAuth
// @Param x-access-token header string true "Access token"
// @Router /search [GET]
func SearchHandler(ctx *gin.Context) {
	getI18n, _ := ctx.Get("i18n")

	queryParams := ctx.Request.URL.Query()

	body, err := getGPTResponse(queryParams.Get("search"))

	var tempMap map[string]interface{}
	if err = json.Unmarshal(body, &tempMap); err != nil {
		log.Printf("Error unmarshaling JSON to temp map: %v", err)
		helper.SendErrorDefault(ctx, http.StatusInternalServerError, getI18n.(*i18n.Localizer))
		return
	}

	var response string
	if choices, ok := tempMap["choices"].([]interface{}); ok && len(choices) > 0 {
		if choice, ok := choices[0].(map[string]interface{}); ok {
			if message, ok := choice["message"].(map[string]interface{}); ok {
				if content, ok := message["content"].(string); ok {
					response = content
				} else {
					log.Println("Content not found or not a string")
				}
			} else {
				log.Println("Message not found or not a map")
			}
		} else {
			log.Println("Choice not found or not a map")
		}
	} else {
		log.Println("Choices not found or not an array")
	}

	helper.SendSuccess(ctx, response)
}

func getGPTResponse(search string) ([]byte, error) {
	url := "https://api.groq.com/openai/v1/chat/completions"
	apiKey := os.Getenv("GPT_API_KEY")

	requestBody, err := json.Marshal(map[string]interface{}{
		"messages": []map[string]string{
			{
				"role":    "user",
				"content": search,
			},
		},
		"model": "gemma2-9b-it",
	})

	if err != nil {
		log.Fatalf("Failed to create request body: %v", err)
		return nil, err
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(requestBody))
	if err != nil {
		log.Fatalf("Failed to create HTTP request: %v", err)
		return nil, err
	}

	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatalf("Failed to send HTTP request: %v", err)
		return nil, err
	}
	defer func(Body io.ReadCloser) {
		err = Body.Close()
		if err != nil {

		}
	}(resp.Body)

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("Failed to read response body: %v", err)
		return nil, err
	}

	return body, err
}
