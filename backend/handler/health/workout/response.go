package workout

import (
	"github.com/EduHSilva/routine/schemas/health/workout"
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
	Instructions string  `json:"instructions"`
	Load         float64 `json:"load,omitempty"`
	Series       int     `json:"series,omitempty"`
	RestSeconds  int     `json:"rest_seconds,omitempty"`
	Repetitions  int     `json:"repetitions,omitempty"`
	ImageUrl     string  `json:"image_url,omitempty"`
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
	return ResponseDataExercise{
		ID:           exercise.ExerciseID,
		Name:         name,
		BodyPart:     exercise.Exercise.BodyPart,
		Instructions: instructions,
		Load:         exercise.Load,
		Series:       exercise.Series,
		RestSeconds:  exercise.RestSeconds,
		Repetitions:  exercise.Repetitions,
		ImageUrl:     exercise.Exercise.GifUrl,
	}
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
