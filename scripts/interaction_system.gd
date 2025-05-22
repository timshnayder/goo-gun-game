extends Node2D
@onready var interactbutton = $KeyboardE
var curINT = []
var canInteract = true

func _input(event):
	if event.is_action_pressed("interact") and canInteract:
		if curINT:
			canInteract = false
			interactbutton.hide()
			
			curINT[0].interaction.call()
			
			canInteract = true

func proxSort(area1, area2):
	var d1 = global_position.distance_to(area1.global_position)
	var d2 = global_position.distance_to(area2.global_position)
	return d1 < d2

func _process(delta):
	if curINT and canInteract:
		curINT.sort_custom(proxSort)
		if curINT[0].interactable:
			interactbutton.position = curINT[0].global_position + Vector2(0,-50)
			interactbutton.show()
	else:
		interactbutton.hide()

func _on_interact_field_area_entered(area):
	curINT.push_back(area)


func _on_interact_field_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	curINT.erase(area)
