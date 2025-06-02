extends Control

@onready var main = $"../../../../"

func _ready() -> void:
	set_visible(false)

func visible() -> void:
	set_visible(true)
	
func _on_resume_pressed():
	main.pauseMenu()
	
func _on_quit_pressed():
	get_tree().quit()
	
	
