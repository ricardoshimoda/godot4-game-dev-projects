extends CharacterBody2D

signal life_changed
signal died

@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300
@export var max_jumps = 2
@export var double_jump_factor = 1.5
@export var climb_speed = 50

var jump_count = 0
var is_on_ladder = false

enum { IDLE, RUN, JUMP, HURT, DEAD, CLIMB }
var state = IDLE

var life = 3: set = set_life

func set_life(value):
	life = value
	life_changed.emit(value)
	if life <=0:
		change_state(DEAD)

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
			if (velocity.x == 0):
				print ("this is weird")
		HURT:
			$Hurt.play()
			$AnimationPlayer.play("hurt")
			life -= 1
			if life > 0:
				var bounce_velocity = velocity.x
				if (bounce_velocity == 0):
					bounce_velocity = run_speed
				velocity.y = -200
				velocity.x = -100 * sign(bounce_velocity)
				await get_tree().create_timer(0.5).timeout
				change_state(IDLE)
		JUMP:
			$Jump.play()
			jump_count = 1
			$AnimationPlayer.play("jump_up")
		DEAD:
			died.emit()
			hide()
		CLIMB:
			$AnimationPlayer.play("climb")
			
func get_input():
	if state == HURT:
		return
	
	var up = Input.is_action_pressed("climb")
	var down = Input.is_action_pressed("down")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	
	velocity.x = 0
	velocity.y = 0
	
	if up and state != CLIMB and is_on_ladder:
		change_state(CLIMB)
	if state == CLIMB:
		if up:
			velocity.y = -climb_speed
			$AnimationPlayer.play("climb")
		elif down:
			velocity.y = climb_speed
			$AnimationPlayer.play("climb")
		else:
			velocity.y = 0
			$AnimationPlayer.stop()
	if state == CLIMB and not is_on_ladder:
		change_state(IDLE)
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	#double-jumping
	if jump and state == JUMP and jump_count < max_jumps and jump_count > 0:
		$Jump.play()
		$AnimationPlayer.play("jump_up")
		velocity.y = jump_speed / double_jump_factor
		jump_count += 1
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0 #resets jump every time it touches the ground
		if not jump:
			$Dust.emitting = true
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE,RUN] and !is_on_floor():
		change_state(JUMP)

func _physics_process(delta):
	if state != CLIMB:
		velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage()
				velocity.y = -200
			else:
				hurt()

func reset(_position):
	life = 3
	position = _position
	show()
	change_state(IDLE)

func hurt():
	if state != HURT:
		change_state(HURT)
