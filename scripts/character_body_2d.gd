extends CharacterBody2D

func processPhysics(delta):
	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 150
	move_and_slide()
	
