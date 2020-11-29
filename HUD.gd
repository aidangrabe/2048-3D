extends Spatial


onready var score_label = $Viewport/Control/VBoxContainer/ScoreLabel
onready var highest_cube_label = $Viewport/Control/VBoxContainer/HighestCubeLabel


func set_score(score):
	var text = "Score: " + format_number(score)
	score_label.text = text

func set_highest_cube_value(value):
	var text = "Highest Cube: " + format_number(value)
	highest_cube_label.text = text

func format_number(value):
	var v = int(value)
	var output = ""
	
	while v > 0:
		var r = v % 1000
		v = v / 1000
		var format = ",%03d"

		if v <= 0:
			format = "%d"

		output = format % r + output
		
	return output
