extends Node2D

@export var startX: float
@export var endX: float
@export var moveDir: int = 1

@onready var player = $"../Player"

var onPlatform: bool = false;

var xPos: float
var moveAmount: float = 8


func _ready() -> void:
	xPos = startX
	player = get_parent().find_child("Player")

func _process(delta: float) -> void:
	if xPos >= endX:
		moveDir = -1
	if xPos <= startX:
		moveDir = 1
		
	xPos += moveAmount * moveDir 
	position.x = xPos
	
	if onPlatform: 
		player.position.x += moveAmount * moveDir
	


func _on_area_2d_2_body_entered(body) -> void:
	if body.is_in_group("Player"):
		onPlatform = true


func _on_area_2d_2_body_exited(body) -> void:
	onPlatform = false
