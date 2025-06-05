extends Node2D

@export var startX: float
@export var endX: float
@export var moveDir: int = 1

@onready var player = $"../../Player"

var onPlatform: bool = false;

var xPos = endX
var moveAmount: float = 5
@onready var tile = $AnimatedSprite2D
@onready var tile2 = $AnimatedSprite2D2


func _ready() -> void:
	tile.play("default")
	tile2.play("default")
	xPos = endX
	SignalBus.connect("dialog_finished", Callable(self, "movetoopen"))

func movetoopen(queue):
	if queue == "computer1":
		moveDir = -1

func _process(delta: float) -> void:
	if xPos <= startX && not onPlatform:
		moveDir = 0
		
	xPos += moveAmount * moveDir 
	position.x = xPos
	
	if onPlatform: 
		player.position.x += moveAmount * moveDir
	


func _on_area_2d_2_body_entered(body) -> void:
	if body is CharacterBody2D:
		onPlatform = true
		moveDir = 1


func _on_area_2d_2_body_exited(body) -> void:
	if body is CharacterBody2D:
		onPlatform = false
		moveDir = -1
