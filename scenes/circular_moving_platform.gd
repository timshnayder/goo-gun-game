extends Node2D

@export var radius: float = 120.0

@export var speed: float = 1.0

@onready var player = $"../Player"
@onready var movPlatform = $"../MovingPlatform"
@onready var timer = $StaticBody2D/Timer
@onready var staticBody = $"../MovingPlatform/StaticBody2D"

var onPlatform: bool = false;

var xPos: float
var moveAmount: float = 8
var center: Vector2
var angle: float = PI / 2 



func _ready() -> void:
	player = get_parent().find_child("Player")
	center = position + Vector2(0, -radius)

func _process(delta: float) -> void:
	print(center)
	angle += speed * delta
	var new_pos = center + Vector2(cos(angle), sin(angle)) * radius
	var move_delta = new_pos - position
	position = new_pos
	
	if onPlatform:
		player.position += move_delta
	
func _on_area_2d_2_body_entered(body) -> void:
	if body.is_in_group("Player"):
		onPlatform = true
func _on_area_2d_2_body_exited(body) -> void:
	onPlatform = false
	
