extends Control
@onready var jump = $Panel/Panel/jmp
@onready var speed = $Panel/Panel/sped

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(num):
	if num == 1:
		jump.show()
		speed.hide()
	elif num == 2:
		speed.show()
		jump.hide()
