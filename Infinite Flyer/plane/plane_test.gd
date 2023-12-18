extends Node3D

@export var forward_speed = 0

func _process(delta):
	$Camera3D.position.z += forward_speed * delta
