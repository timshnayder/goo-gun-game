extends Control



func start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/BuildSet/level_1_set.tscn")


func quit_pressed() -> void:
	get_tree().quit()
