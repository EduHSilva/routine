package workout

import (
	"encoding/json"
	"fmt"
	"github.com/EduHSilva/routine/schemas/health/workout"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

type ResponseExercises struct {
	Message string               `json:"message"`
	Data    ResponseDataExercise `json:"data"`
}

type ResponseDataExercise struct {
	ID           uint    `json:"id"`
	Name         string  `json:"name"`
	BodyPart     string  `json:"body_part"`
	Target       string  `json:"target"`
	Instructions string  `json:"instructions"`
	Load         float64 `json:"load,omitempty"`
	Series       int     `json:"series,omitempty"`
	RestSeconds  int     `json:"rest_seconds,omitempty"`
	Repetitions  int     `json:"repetitions,omitempty"`
	ImageUrl     string  `json:"image_url,omitempty"`
	Notes        string  `json:"notes,omitempty"`
}

type ResponseData struct {
	ID        uint                   `json:"id"`
	CreateAt  time.Time              `json:"createAt"`
	UpdateAt  time.Time              `json:"updateAt"`
	DeletedAt time.Time              `json:"deletedAt,omitempty"`
	Name      string                 `json:"name"`
	Exercises []ResponseDataExercise `json:"exercises"`
}

type ResponseWorkout struct {
	Message string       `json:"message"`
	Data    ResponseData `json:"data"`
}

func ConvertExerciseToResponse(exercise workout.ExerciseWorkout, locale any) ResponseDataExercise {
	var name = ""
	var instructions = ""
	if locale == "pt_BR" {
		name = exercise.Exercise.NamePt
		instructions = exercise.Exercise.InstructionsPt
	} else {
		name = exercise.Exercise.Name
		instructions = exercise.Exercise.Instructions
	}

	imageUrl := getImageUrl(exercise.Exercise.ExternalID)

	return ResponseDataExercise{
		ID:           exercise.ExerciseID,
		Name:         name,
		BodyPart:     exercise.Exercise.BodyPart,
		Instructions: instructions,
		Load:         exercise.Load,
		Series:       exercise.Series,
		RestSeconds:  exercise.RestSeconds,
		Repetitions:  exercise.Repetitions,
		ImageUrl:     imageUrl,
		Notes:        exercise.Notes,
	}
}

func getImageUrl(externalID string) string {
	url := fmt.Sprintf("https://exercisedb.p.rapidapi.com/exercises/exercise/%s", externalID)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatal(err)
	}

	host := os.Getenv("EXERCISES_API_HOST")
	token := os.Getenv("EXERCISES_API_KEY")

	req.Header.Add("x-rapidapi-host", host)
	req.Header.Add("x-rapidapi-key", token)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer func(Body io.ReadCloser) {
		err = Body.Close()
		if err != nil {

		}
	}(resp.Body)

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	var data map[string]interface{}
	if err = json.Unmarshal(body, &data); err != nil {
		log.Fatal(err)
	}

	if gifUrl, ok := data["gifUrl"].(string); ok {
		return gifUrl
	}

	return ""
}

func ConvertWorkoutToWorkoutResponse(workout *workout.Workout, locale any) ResponseData {
	exercisesResponse := make([]ResponseDataExercise, len(workout.Exercises))

	for i, exercise := range workout.Exercises {
		exercisesResponse[i] = ConvertExerciseToResponse(exercise, locale)
	}

	return ResponseData{
		ID:        workout.ID,
		CreateAt:  workout.CreatedAt,
		UpdateAt:  workout.UpdatedAt,
		DeletedAt: workout.DeletedAt.Time,
		Name:      workout.Name,
		Exercises: exercisesResponse,
	}
}
