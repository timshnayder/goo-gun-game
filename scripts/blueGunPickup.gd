extends Area2D



func _on_body_entered(body: Node2D) -> void:
	visible=false;
	get_tree().call_group("Player","pickedUpBlueGun")
