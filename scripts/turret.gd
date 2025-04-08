extends Node2D

@onready var ray_cast = $RayCast2D
@onready var timer = $Timer
@export var ammo : PackedScene
@onready var player = $"../Player"

func _ready():
	player = get_parent().find_child("Player")

func _physics_process(delta):
	_aim()
	_check_player_collision()
	
func _aim():
	ray_cast.target_position = to_local(player.position)

func _check_player_collision():
	if ray_cast.get_collider() == player and timer.is_stopped():
		print("found")
		timer.start()
	elif ray_cast.get_collider() != player and not timer.is_stopped():
		print("not found")
		timer.stop()

func _on_timer_timeout():
	player.kill() 

	
