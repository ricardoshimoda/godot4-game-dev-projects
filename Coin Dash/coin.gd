extends Area2D
var screensize = Vector2.ZERO
var coinsize = Vector2(50, 50)

func pickup():
	queue_free()
