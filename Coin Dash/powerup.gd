extends Area2D

var screensize = Vector2.ZERO
var coinsize = Vector2(50, 50)

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()

func _on_lifetime_timeout():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(50, screensize.x - 50), randi_range(50, screensize.y - 50))

