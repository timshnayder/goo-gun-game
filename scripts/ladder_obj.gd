extends Area2D


func _on_body_entered(body: Node2D) -> void:
	get_tree().call_group("Player","entered_ladder")



func _on_body_exited(body: Node2D) -> void:
	get_tree().call_group("Player","exited_ladder")
