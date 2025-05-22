extends Node2D

@export var start_angle_deg: float = -45
@export var end_angle_deg: float = 45
@export var rotation_speed_deg: float = 45

var rotating_forward: bool = true

@onready var ray = $LaserRay
@onready var line = $LaserLine
@onready var player = $"../Player"

func _ready() -> void:
	ray.rotation_degrees=start_angle_deg

func _process(delta: float) -> void:
	if rotating_forward:
		ray.rotation_degrees += rotation_speed_deg * delta
		if ray.rotation_degrees >= end_angle_deg:
			ray.rotation_degrees = end_angle_deg
			rotating_forward = false
	else:
		ray.rotation_degrees -= rotation_speed_deg * delta
		if ray.rotation_degrees <= start_angle_deg:
			ray.rotation_degrees = start_angle_deg
			rotating_forward = true
	
	# Only add this collision check (keep your existing line drawing)
	if ray.is_colliding() and ray.get_collider() == player:
		player.kill()
	
	var laser_end = ray.get_collision_point()
	line.points = [Vector2.ZERO, laser_end-global_position]

	
	
	
	
	
