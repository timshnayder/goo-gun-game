extends Area2D

@export var interactable = true
@export var key = ""

var active = false

var interaction: Callable = func():
	SignalBus.emit_signal("display_dialog", key)
	
