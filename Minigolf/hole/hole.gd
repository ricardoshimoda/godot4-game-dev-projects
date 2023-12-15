extends Node3D

enum {START, AIM, SET_POWER, SHOOT, WIN}

@export var power_speed = 100
@export var angle_speed = 1.1

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

func change_state(new_state):
	state = new_state
	match state:
		AIM:
			$Arrow.position = $Ball.position
			$Arrow.show()
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
	if event.is_action_pressed("click"):
		match state:
			AIM:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)

func _process(delta):
	match state:
		AIM:
			animate_arrow(delta)
		SET_POWER:
			animate_power(delta)
		SHOOT:
			pass

func animate_arrow(delta):
	$Arrow.rotation.y += angle_speed * angle_change * delta
	if $Arrow.rotation.y > PI / 2:
		angle_change = -1
	if $Arrow.rotation.y < -PI/2:
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
