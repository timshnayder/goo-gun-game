extends Control
@onready var jump = $Toggle/jmp
@onready var speed = $Toggle/sped
@onready var sticky = $Toggle/sticky

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
		sticky.hide()
	elif num == 2:
		speed.show()
		jump.hide()
		sticky.hide()
	elif num == 3:
		sticky.show()
		jump.hide()
		speed.hide()
