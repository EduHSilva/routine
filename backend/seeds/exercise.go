package seeds

import (
	"encoding/json"
	"fmt"
	"github.com/EduHSilva/routine/schemas/health/workout"
	gt "github.com/bas24/googletranslatefree"
	"gorm.io/gorm"
	"html/template"
	"io/ioutil"
	"log"
	"strings"
)

type ExerciseInput struct {
	Name         string   `json:"name"`
	BodyPart     string   `json:"bodyPart"`
	Instructions []string `json:"instructions"`
	GifUrl       string   `json:"gifUrl"`
	ID           string   `json:"id"`
}

func instructionsToHTML(instructions []string) string {
	var htmlInstructions strings.Builder
	for _, instr := range instructions {
		htmlInstructions.WriteString(fmt.Sprintf("<p>%s</p>", template.HTMLEscapeString(instr)))
	}
	return htmlInstructions.String()
}

func loadExercisesFromFile(db *gorm.DB, filePath string) error {
	file, err := ioutil.ReadFile(filePath)
	if err != nil {
		return err
	}

	var inputs []ExerciseInput
	err = json.Unmarshal(file, &inputs)
	if err != nil {
		return err
	}

	for _, input := range inputs {
		htmlInstructions := instructionsToHTML(input.Instructions)

		exercise := workout.Exercise{
			Name:           input.Name,
			NamePt:         translateFromFile(input.Name, loadTranslations()),
			BodyPart:       input.BodyPart,
			Instructions:   htmlInstructions,
			InstructionsPt: translate(htmlInstructions),
			ExternalID:     input.ID,
		}
		db.Create(&exercise)
	}

	return nil
}

func translate(text string) string {
	result, _ := gt.Translate(text, "en", "pt")
	return result
}

func loadTranslations() map[string]string {
	file, err := ioutil.ReadFile("seeds/json/exercises_translations.json")
	if err != nil {
		log.Fatalf("Erro ao carregar o arquivo de traduções: %v", err)
	}

	var translations map[string]string
	err = json.Unmarshal(file, &translations)
	if err != nil {
		log.Fatalf("Erro ao fazer o parse do arquivo de traduções: %v", err)
	}

	return translations
}

func translateFromFile(text string, translations map[string]string) string {
	if translation, exists := translations[text]; exists {
		return translation
	}
	return text
}

func loadExerciseFromFile(db *gorm.DB) {
	err := loadExercisesFromFile(db, "seeds/json/exercises.json")
	if err != nil {
		log.Fatalf("Error loading exercises from JSON: %v", err)
	}
}
