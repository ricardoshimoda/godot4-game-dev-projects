extends Node

# This is my first script that's not directly serving a scene!
# This is kind of exciting!

var num_levels = 2
var current_level = 0

var game_scene = "res://main.tscn"
var title_screen = "res://ui/title.tscn"

func restart():
	current_level = 0
	get_tree().change_scene_to_file(title_screen)

func next_level():
	current_level += 1
	if (current_level <= num_levels):
		get_tree().call_deferred("change_scene_to_file", game_scene)
