extends CharacterBody2D

@onready var blueGoo = preload("res://scenes/blue-goo-projectile.tscn")
@onready var orangeGoo = preload("res://scenes/orange-goo-projectile.tscn")
@onready var gun = $Gun

@export var maxSpeed = 300
@export var gravity = 40
@export var maxGravity = 500
@export var jumpForce = 700

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if(velocity.y > maxGravity):
			velocity.y=maxGravity
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = -jumpForce
	
	if Input.is_action_pressed("shoot-blue"):
		var goo = blueGoo.instantiate()
		goo.pos=global_position
		goo.rota=gun.rotation
		get_parent().add_child(goo)
	if Input.is_action_pressed("shoot-orange"):
		var goo = orangeGoo.instantiate()
		goo.pos=global_position
		goo.rota=gun.rotation
		get_parent().add_child(goo)
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x=maxSpeed*horizontal_direction
	move_and_slide()
