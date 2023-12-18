extends CharacterBody3D

@export var pitch_speed = 1.1
@export var roll_speed = 2.5
@export var level_speed = 4.0

var roll_input = 0
var pitch_input = 0

func get_input():
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	roll_input = Input.get_axis("roll_left", "roll_right")

func _physics_process(delta):
	get_input()
	
	rotation.x = lerpf(rotation.x, pitch_input, pitch_speed * delta)
	rotation.x = clamp(rotation.x, -PI/4, PI/4)
	
	
