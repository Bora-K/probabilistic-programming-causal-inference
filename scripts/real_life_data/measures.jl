seqn = "SEQN"
weight = "BMXWT"  # kg
height = "BMXHT"  # cm
bmi = "BMXBMI"  # kg/m^2
gender = "RIAGENDR"
gender_dict = Dict(1 => "male", 2 => "female")
age = "RIDAGEYR"  # years, 80+ is 80
vitamin_d = "LBXVIDMS"  # nmol/L
avg_alcohol = "ALQ130"  # drinks/day
poverty_index = "INDFMMPI"  # ratio
sedentary_minutes = "PAD680"  # minutes
vigorous_rec_activity = "PAQ650"  # categorical
vigorous_rec_activity_dict = Dict(1 => "Yes", 2 => "No", 7 => "Refused", 9 => "Don't know")
feel_depressed = "DPQ020"  # categorical
feel_depressed_dict = Dict(0 => "Not at all", 1 => "Several days", 2 => "More than half the days", 3 => "Nearly every day", 7 => "Refused", 9 => "Don't know")
feel_tired = "DPQ040"  # categorical
feel_tired_dict = Dict(0 => "Not at all", 1 => "Several days", 2 => "More than half the days", 3 => "Nearly every day", 7 => "Refused", 9 => "Don't know")
thought_better_off_dead = "DPQ090"  # categorical
thought_better_off_dead_dict = Dict(0 => "Not at all", 1 => "Several days", 2 => "More than half the days", 3 => "Nearly every day", 7 => "Refused", 9 => "Don't know")
depression_difficulty = "DPQ100"  # categorical
depression_difficulty_dict = Dict(0 => "Not at all difficult", 1 => "Somewhat difficult", 2 => "Very difficult", 3 => "Extremely difficult", 7 => "Refused", 9 => "Don't know")
smoke_now = "SMQ040"  # categorical
smoke_now_dict = Dict(1 => "Every day", 2 => "Some days", 3 => "Not at all", 7 => "Refused", 9 => "Don't know")
