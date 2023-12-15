extends Node3D

enum {START, AIM, SET_POWER, SHOOT, WIN}

@export var power_speed = 100
@export var angle_speed = 1.1
@export var mouse_sensitivity = 150

var angle_change = 1
var power = 0: set = set_power
var power_change = 1
var shots = 0: set = set_shot
var state = START
var hole_dir

func set_power(value):
	power = value
	$UI.update_power(power)

func set_shot(value):
	shots = value
	$UI.update_shots(shots)

func _ready():
	$Arrow.hide()
	$Ball.position = $Tee.position
	$UI.show_message("Get Ready!")
	
func set_start_angle():
	var hole_position = Vector2($Target.position.x, $Target.position.z)
	var ball_position = Vector2($Ball.position.x, $Ball.position.z)
	hole_dir = (hole_position - ball_position).angle() + PI/2
	$Arrow.rotation.y = hole_dir
	
func change_state(new_state):
	state = new_state
	match state:
		AIM:
			$Arrow.position = $Ball.position
			$Arrow.position.y -= 0.05
			$Arrow.show()
			set_start_angle()
		SET_POWER:
			power = 0
		SHOOT:
			$Arrow.hide()
			$Ball.shoot($Arrow.rotation.y, power/15)
			shots += 1
		WIN:
			$Ball.hide()
			$Arrow.hide()
			$UI.show_message("Win!")

func _input(event):
	if event is InputEventMouseMotion and state == AIM:
		$Arrow.rotation.y -= event.relative.x / mouse_sensitivity
	if event.is_action_pressed("click"):
		match state:
			AIM:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)

func _process(delta):
	match state:
		SET_POWER:
			animate_power(delta)
		SHOOT:
			pass

func animate_arrow(delta):
	$Arrow.rotation.y += angle_speed * angle_change * delta
	if $Arrow.rotation.y > hole_dir + PI/2:
		angle_change = -1
	if $Arrow.rotation.y < hole_dir - PI/2:
		angle_change = 1

func animate_power(delta):
	power += power_speed * power_change * delta
	if power >= 100:
		power_change = -1
	if power <= 0:
		power_change = 1
	
func _on_hole_body_entered(body):
	if body.name == "Ball":
		change_state(WIN)

func _on_ball_stopped():
	if state == SHOOT:
		change_state(AIM)

func _on_ball_touching():
	if state == START:
		change_state(AIM)
