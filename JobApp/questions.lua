local Questions = {

	{
		Id = 1,
		Type = "Choice", -- "Choice" or "Typing"
		Question = "Do you agree to follow all rules?",
		Options = {"Yes", "No"},
		CorrectAnswers = {"Yes"},
		Points = 20
	},

	{
		Id = 2,
		Type = "Typing",
		Question = "Why do you want this job?",
		CorrectAnswers = {
			"to help",
			"help players",
			"moderate",
			"support"
		},
		Points = 30
	},

	{
		Id = 3,
		Type = "Choice",
		Question = "Have you moderated before?",
		Options = {"Yes", "No"},
		CorrectAnswers = {"Yes"},
		Points = 20
	}

}

return Questions

