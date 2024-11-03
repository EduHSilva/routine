package seeds

import (
	"encoding/json"
	"fmt"
	"github.com/EduHSilva/routine/schemas/enums"
	"github.com/EduHSilva/routine/schemas/health/workout"
	gt "github.com/bas24/googletranslatefree"
	"html/template"
	"io/ioutil"
	"log"
	"strings"
)

type ExerciseInput struct {
	Name         string                   `json:"name"`
	BodyPart     string                   `json:"bodyPart"`
	Instructions []InstructionInput       `json:"instructions"`
	Muscles      map[string][]MuscleInput `json:"muscles"`
	Alternatives []AlternativeInput       `json:"alternatives"`
	Variations   []VariationInput         `json:"variations"`
}

type InstructionInput struct {
	Description string `json:"description"`
	Order       int    `json:"order"`
}

type MuscleInput struct {
	Name  string   `json:"name"`
	Group string   `json:"group"`
	Heads []string `json:"heads"`
}

type AlternativeInput struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
}

type VariationInput struct {
	ID   uint   `json:"id"`
	Name string `json:"name"`
}

func instructionsToHTML(instructions []InstructionInput) string {
	var htmlInstructions strings.Builder
	for _, instr := range instructions {
		htmlInstructions.WriteString(fmt.Sprintf("<p>%d. %s</p>", instr.Order, template.HTMLEscapeString(instr.Description)))
	}
	return htmlInstructions.String()
}

func loadExercisesFromFile(filePath string) ([]workout.Exercise, error) {
	file, err := ioutil.ReadFile(filePath)
	var exercises []workout.Exercise
	if err != nil {
		return nil, err
	}

	var inputs []ExerciseInput
	err = json.Unmarshal(file, &inputs)
	if err != nil {
		return nil, err
	}

	for _, input := range inputs {
		htmlInstructions := instructionsToHTML(input.Instructions)

		exercise := workout.Exercise{
			Name:           input.Name,
			NamePt:         translateFromFile(input.Name, loadTranslations()),
			BodyPart:       input.BodyPart,
			Instructions:   htmlInstructions,
			InstructionsPt: translate(htmlInstructions),
		}

		for _, alt := range input.Alternatives {
			exercise.Alternatives = append(exercise.Alternatives, workout.Alternative{
				Name: alt.Name,
			})
		}

		for _, varr := range input.Variations {
			exercise.Variations = append(exercise.Variations, workout.Variation{
				Name: varr.Name,
			})
		}

		for function, muscles := range input.Muscles {
			for _, muscle := range muscles {
				exerciseMuscle := workout.ExerciseMuscle{
					Muscle: workout.Muscle{
						Name:  muscle.Name,
						Group: muscle.Group,
					},
					Function: enums.MuscleFunction(strings.Title(function)),
				}

				for _, head := range muscle.Heads {
					exerciseMuscle.Muscle.Heads = enums.MuscleHead(strings.Title(head))
				}

				exercise.Muscles = append(exercise.Muscles, exerciseMuscle)
			}
		}
		exercises = append(exercises, exercise)

		fmt.Printf("Exercise %s saved successfully!\n", input.Name)
	}

	return exercises, nil
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

func loadExerciseFromFile() *[]workout.Exercise {
	exercises, err := loadExercisesFromFile("seeds/json/exercises_details.json")
	if err != nil {
		log.Fatalf("Error loading exercises from JSON: %v", err)
	}
	return &exercises
}
