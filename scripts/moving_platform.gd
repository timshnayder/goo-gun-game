extends Node2D

@export var startX: float
@export var endX: float
@export var moveDir: int = 0

@onready var player = $"../../Player"

var onPlatform: bool = false;
var dir

var moveAmount: float = 5
@onready var tile = $AnimatedSprite2D
@onready var tile2 = $AnimatedSprite2D2
@onready var leavetime = $StaticBody2D/Area2D2/Timer

func _ready() -> void:
	if(startX<endX):
		dir=1
	else:
		dir=-1
	tile.play("default")
	tile2.play("default")
	position.x=endX
	SignalBus.connect("dialog_finished", Callable(self, "movetoopen"))

func movetoopen(queue):
	if queue == "computer":
		moveDir = -1

func _process(delta: float) -> void:
	position.x += moveAmount * moveDir * dir
	if onPlatform: 
		player.position.x += moveAmount * moveDir * dir
		
	if dir == 1:
		if position.x <= startX:
			moveDir = 0
			position.x = startX
	else:
		if position.x >= startX:
			moveDir = 0
			position.x = startX

func _on_area_2d_2_body_entered(body) -> void:
	if body is CharacterBody2D:
		leavetime.start()
		onPlatform = true
		moveDir = 1


func _on_area_2d_2_body_exited(body) -> void:
	if body is CharacterBody2D:
		leavetime.stop()
		leavetime.wait_time = 2.0
		onPlatform = false
		moveDir = -1


func _on_timer_timeout():
	moveDir = 1
