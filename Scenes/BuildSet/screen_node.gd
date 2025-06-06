extends Area2D

@export var interactable = true
@export var key : String
var active = false

func _ready():
	SignalBus.connect("dialog_finished", Callable(self, "unlockgate"))

func unlockgate(given_key):
	if key == given_key:
		interactable = false


var interaction: Callable = func():
	if interactable:
		SignalBus.emit_signal("display_dialog", key)
	
	
	
	
