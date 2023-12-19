extends Control

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _ready():
	if Global.high_score <= 0:
		$HighScore.hide()
	else:
		$HighScore.text = "High Score: %s" % Global.high_score
