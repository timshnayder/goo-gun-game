extends Area2D

var dir : Vector2 = Vector2.RIGHT
var speed : float = 900

func _physics_process(delta):
	position += dir * speed * delta


func _on_screen_exited():
	queue_free()
