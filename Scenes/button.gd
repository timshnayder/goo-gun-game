extends Button
@onready var infopanel = $"../Panel"

var showing = false

func _ready():
	infopanel.hide()

func _on_pressed():
	showing = not showing
	if showing:
		infopanel.show()
	else:
		infopanel.hide()
