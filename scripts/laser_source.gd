extends Node2D

@export var start_angle_deg: float = -45
@export var end_angle_deg: float = 45
@export var rotation_speed_deg: float = 45

var rotating_forward: bool = true


@onready var ray = $LaserRay
@onready var line = $LaserLine

func _process(delta: float) -> void:
	var laser_end = ray.get_cast_to()
	if ray.is_colliding():
		laser_end = ray.get_collision_point()-global_position
	line.global_position = global_position
	line.points = [Vector2.ZERO, laser_end]
