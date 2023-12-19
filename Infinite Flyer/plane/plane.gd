extends CharacterBody3D

signal explode
signal dead
signal score_changed
signal fuel_changed

@export var pitch_speed = 1.1
@export var roll_speed = 2.5
@export var level_speed = 4.0
@export var forward_speed = 25
@export var fuel_burn = 1.0

var max_fuel = 10.0
var fuel = 10.0: set = set_fuel
var score = 0: set = set_score
var max_altitude = 20
var roll_input = 0
var pitch_input = 0

func set_fuel(value):
	fuel = min(value, max_fuel)
	fuel_changed.emit(fuel)
	if fuel <= 0:
		die()

func set_score(value):
	score = value
	score_changed.emit(score)

func get_input():
	pitch_input = Input.get_axis("pitch_down", "pitch_up")
	roll_input = Input.get_axis("roll_left", "roll_right")
	if position.y >= max_altitude and pitch_input > 0:
		position.y = max_altitude
		pitch_input = 0

func _physics_process(delta):
	get_input()
	
	rotation.x = lerpf(rotation.x, pitch_input, pitch_speed * delta)
	rotation.x = clamp(rotation.x, -PI/4, PI/4)
	$cartoon_plane.rotation.z = lerpf($cartoon_plane.rotation.z, roll_input, roll_speed * delta)
	
	velocity = -transform.basis.z * forward_speed
	velocity += transform.basis.x * ($cartoon_plane.rotation.z / (0.25*PI)) * (forward_speed/2.0)

	move_and_slide()
	
	fuel -= fuel_burn * delta
	
	if get_slide_collision_count() > 0:
		die()
		
func die():
	explode.emit()
	$Boom.play(0.20)
	set_physics_process(false)
	$cartoon_plane.hide()
	$Explosion.show()
	$Explosion.play("default")
	if score > Global.high_score:
		Global.high_score = score
		Global.save_score()
	await $Explosion.animation_finished
	await $Boom.finished
	$Explosion.hide()
	await get_tree().create_timer(1).timeout
	dead.emit()
