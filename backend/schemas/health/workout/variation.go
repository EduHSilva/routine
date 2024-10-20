package workout

type Variation struct {
	ID         uint   `gorm:"primaryKey"`
	ExerciseID uint   `json:"exercise_id"`
	Name       string `json:"name"`
}
