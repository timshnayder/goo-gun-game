extends Area2D
@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer

func _on_body_entered(body):
	if body is CharacterBody2D:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int()+1
		var next_level_path = "res://scenes/BuildSet/level_" + str(next_level_number) + "_set.tscn"
		SceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(next_level_path)
