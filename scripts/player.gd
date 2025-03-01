extends CharacterBody2D

@export var maxSpeed = 300
@export var gravity = 30
@export var maxGravity = 400
@export var jumpForce = 700

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if(velocity.y > maxGravity):
			velocity.y=maxGravity
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = -jumpForce
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x=maxSpeed*horizontal_direction
	move_and_slide()
	print(velocity)
