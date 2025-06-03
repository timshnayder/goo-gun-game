extends Node2D

@export var startX: float
@export var endX: float
@export var moveDir: int = 1
@export var crumblingOn: bool

var crumbleActive: bool = false

@onready var player = $"../Player"
@onready var movPlatform = $"../MovingPlatform"
@onready var timer = $StaticBody2D/Timer
@onready var staticBody = $"../MovingPlatform/StaticBody2D"

var onPlatform: bool = false;

var xPos: float
var moveAmount: float = 8


func _ready() -> void:
	xPos = startX
	player = get_parent().find_child("Player")
	timer.one_shot = true
	timer.wait_time = 2.0

func _process(delta: float) -> void:
	if xPos >= endX:
		moveDir = -1
	if xPos <= startX:
		moveDir = 1
		
	xPos += moveAmount * moveDir 
	position.x = xPos
		
	if onPlatform:
		if(crumblingOn && crumbleActive):
			get_node("StaticBody2D/CollisionShape2D").disabled = true
			get_node("StaticBody2D/Area2D2/CollisionShape2D").disabled = true
			hide()
			onPlatform = false
		else:
			player.position.x += moveAmount * moveDir
	
func _on_area_2d_2_body_entered(body) -> void:
	if body.is_in_group("Player"):
		onPlatform = true
		timer.start()
func _on_area_2d_2_body_exited(body) -> void:
	onPlatform = false
func _on_timer_timeout() -> void:
	crumbleActive = true
	
