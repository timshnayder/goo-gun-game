extends CharacterBody2D

@onready var blueGoo = preload("res://scenes/blue-goo-projectile.tscn")
@onready var orangeGoo = preload("res://scenes/orange-goo-projectile.tscn")
@onready var gun = $Gun
@onready var tilemap = $"../TileMapNode/Surfaces"

@export var maxSpeed = 300
@export var gravity = 30
@export var maxGravity = 700
@export var jumpForce = 500

@export var accel = 30
@export var airresist = 5

func _physics_process(delta):
	if is_on_floor():
		var tilePos = tilemap.local_to_map(tilemap.to_local(position));
		tilePos.y+=2
		var tileId = tilemap.get_cell_source_id(tilePos)
		if tileId == 0 || tileId == -1: # air or ground
			accel = 30
			maxSpeed = 300
			jumpForce = 500
		if tileId == 1: #blue goo
			accel = 10
			maxSpeed = 300
			jumpForce= 1100
		if tileId == 2: #orange goo
			accel = 10
			maxSpeed = 600
			jumpForce= 500
		
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
	if horizontal_direction == 0 || velocity.x > maxSpeed || velocity.x<-maxSpeed:
		if is_on_floor():
			if velocity.x > 0:
				if velocity.x-accel*sign(velocity.x) <= 0:
					velocity.x = 0
				else:
					velocity.x -= accel*sign(velocity.x)
			if velocity.x < 0:
				if velocity.x-accel*sign(velocity.x) >= 0:
					velocity.x = 0
				else:
					velocity.x -= accel*sign(velocity.x)
			
		else:
			velocity.x -= airresist*sign(velocity.x)
	else: 
		velocity.x+=accel*horizontal_direction
	

		
	move_and_slide()
