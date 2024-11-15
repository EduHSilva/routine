package seeds

import "github.com/EduHSilva/routine/schemas"

var users = []schemas.User{
	{
		Name:           "Admin",
		Email:          "admin@gmail.com",
		Password:       "$2a$14$aEd9RlY0uyT0Do9ir58hueCr4VupLMXe1mzMON8DY6ryLCHtsOVci",
		CurrentBalance: 200.00,
	},
}
