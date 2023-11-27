extends Area2D
signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)
var sizeX = 35
var sizeY = 23

func start():
	set_process(true)
	position = screensize/2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)
	
func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", 
		"ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, sizeX, screensize.x - sizeX)
	position.y = clamp(position.y, sizeY, screensize.y - sizeY)
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_entered(area):
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coins")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
