extends Node2D

@onready var gate = $StaticBody2D/AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	SignalBus.connect("dialog_finished", Callable(self, "movetoopen"))

func movetoopen(queue):
	print("qu?")
	if queue == "computer":
		print("hi")
		gate.play("open")	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		gate.play("ka")
