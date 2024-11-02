package workout

import (
	"github.com/EduHSilva/routine/helper"
)

type CreateWorkoutRequest struct {
	Name      string                   `json:"name"`
	UserID    uint                     `json:"user_id"`
	Exercises []ExerciseWorkoutRequest `json:"exercises"`
}

type ExerciseWorkoutRequest struct {
	WorkoutID   uint    `json:"workout_id"`
	ExerciseID  uint    `json:"exercise_id"`
	Series      int     `json:"series"`
	Load        float64 `json:"load"`
	RestSeconds int     `json:"rest_seconds"`
	Repetitions int     `json:"repetitions"`
}

func (r CreateWorkoutRequest) Validate() error {

	if r.Name == "" {
		return helper.ErrParamIsRequired("name", "string")
	}
	if r.UserID == 0 {
		return helper.ErrParamIsRequired("user_id", "uint")
	}
	if len(r.Exercises) == 0 {
		return helper.ErrParamIsRequired("exercises", "exercise")
	}

	return nil
}

type UpdateWorkoutRequest struct {
	Name      string                   `json:"name"`
	Exercises []ExerciseWorkoutRequest `json:"exercises"`
}

func (r UpdateWorkoutRequest) Validate() error {
	if r.Name == "" {
		return helper.ErrParamIsRequired("name", "string")
	}
	if len(r.Exercises) == 0 {
		return helper.ErrParamIsRequired("exercises", "exercise")
	}
	return nil
}
