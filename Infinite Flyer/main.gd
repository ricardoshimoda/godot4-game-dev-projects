extends Node3D

var chunk = preload("res://buildings/chunk.tscn")
var num_chunks = 1
var chunk_size = 200
var max_position = -100
var title_screen = "res://ui/title_screen.tscn"

func _process(_delta):
	if $Plane.position.z < max_position:
		num_chunks += 1
		var new_chunk = chunk.instantiate()
		new_chunk.position.z = max_position - chunk_size / 2.0
		new_chunk.level = num_chunks / 4.0
		add_child(new_chunk)
		max_position -= chunk_size
		
func _on_plane_dead():
	get_tree().change_scene_to_file(title_screen)

func _on_plane_explode():
	$LevelSound.stop()
