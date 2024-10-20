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
	Load         float64 `json:"load"`
	Series       int     `json:"series"`
	RestSeconds  int     `json:"rest_seconds"`
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

func ConvertExerciseToResponse(exercise workout.ExerciseWorkout) ResponseDataExercise {
	return ResponseDataExercise{
		ID:           exercise.ExerciseID,
		Name:         exercise.Exercise.Name,
		BodyPart:     exercise.Exercise.BodyPart,
		Instructions: exercise.Exercise.Instructions,
		Load:         exercise.Load,
		Series:       exercise.Series,
		RestSeconds:  exercise.RestSeconds,
	}
}

func ConvertWorkoutToWorkoutResponse(workout *workout.Workout) ResponseData {
	exercisesResponse := make([]ResponseDataExercise, len(workout.Exercises))

	for i, exercise := range workout.Exercises {
		exercisesResponse[i] = ConvertExerciseToResponse(exercise)
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
