extends Node2D

@export var startX: float
@export var endX: float

@onready var player = $"../../Player"

var onPlatform: bool = false;
var dir

var moveAmount: float = 5
@onready var tile = $AnimatedSprite2D
@onready var tile2 = $AnimatedSprite2D2
@onready var leavetime = $StaticBody2D/Area2D2/Timer

func _ready() -> void:
	position.x=startX
	if(startX < endX):
		dir=1
	else:
		dir=-1

func _process(delta: float) -> void:
	print(position.x)
	position.x += moveAmount * dir
	if onPlatform: 
		player.position.x+=moveAmount* dir
		
	if dir == 1:
		if position.x >= endX:
			position.x = endX
			dir=0
	else:
		if position.x <= endX:
			position.x = endX
			dir=0


func _on_area_2d_2_body_entered(body) -> void:
	
	if body is CharacterBody2D:
		onPlatform = true


func _on_area_2d_2_body_exited(body) -> void:
	if body is CharacterBody2D:
		onPlatform = false
