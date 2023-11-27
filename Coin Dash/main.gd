extends Node2D

@export var coin_scene : PackedScene
@export var powerup_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	despawn_obstacles()
	spawn_obstacles()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func despawn_obstacles():
	for o in get_tree().get_nodes_in_group("obstacles"):
		o.queue_free()

func spawn_obstacles():
	var o = obstacle_scene.instantiate()
	add_child(o)
	o.position = Vector2(randi_range(50, screensize.x-50), randi_range(50,screensize.y - 50))	
	
func spawn_coins():
	var coinborder = 50
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		#print(c.coinsize)
		c.screensize = screensize
		c.position = Vector2(randi_range(coinborder, screensize.x - coinborder),
			randi_range(coinborder, screensize.y - coinborder))
	$LevelSound.play()

func _process(delta):
	if playing and 	get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_obstacles()
		spawn_coins()
		$PowerupTimer.start(randf_range(1, time_left - 5))

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coins":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_hud_start_game():
	new_game()

func _on_powerup_timer_timeout():
	var powerupborder = 50
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(powerupborder, screensize.x - powerupborder), 
		randi_range(powerupborder, screensize.y - powerupborder))
	
