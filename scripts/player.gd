extends CharacterBody2D

@onready var blueGoo = preload("res://scenes/blue_goo_projectile.tscn")
@onready var orangeGoo = preload("res://scenes/orange_goo_projectile.tscn")
@onready var gun = $Gun
@onready var tilemap = $"../MapLayers/Surfaces"
@onready var gameover = $Camera2D/CanvasLayer/gameover
@onready var sprite = $AnimatedSprite2D
@onready var hotbar = $Camera2D/CanvasLayer/hotbar
@export var maxSpeed = 300
@export var gravity = 30
@export var maxGravity = 700
@export var jumpForce = 500
@export var Freeze = false
@export var accel = 30
@export var airresist = 5

var isDead = false
var gooselect = 1



func kill():
	isDead = true
	sprite.hide()
	gun.hide()
	gameover.show()
	gameover.get_node("retry").grab_focus()




func _physics_process(delta):
	if isDead: 
		return
	if is_on_floor():
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
			
		if velocity.x > 0:
			sprite.flip_h = false
		if velocity.x < 0:
			sprite.flip_h = true
		
		var tilePos = tilemap.local_to_map(tilemap.to_local(position));
		tilePos.y+=1
		var tileId = tilemap.get_cell_source_id(tilePos)
		if tileId == 0 || tileId == -1: # air or ground
			accel = 30
			maxSpeed = 300
			jumpForce = 500
		if tileId == 1: #blue goo
			accel = 10
			maxSpeed = 300
			jumpForce= 900
		if tileId == 2: #orange goo
			accel = 10
			maxSpeed = 600
			jumpForce= 500
		
	if !is_on_floor():
		velocity.y += gravity
		if(velocity.y > maxGravity):
			velocity.y=maxGravity
	
	if Input.is_action_pressed("jump") && is_on_floor() && not Freeze:
		velocity.y = -jumpForce
		sprite.play("jump")
		
	if Input.is_action_just_pressed("toggle") && not Freeze:
		gooselect += 1
		if (gooselect > 2):
			gooselect = 0
		hotbar.update(gooselect)
		
				
	if Input.is_action_pressed("shoot") && not Freeze:
		var goo = blueGoo.instantiate()
		if gooselect == 1:
			goo = blueGoo.instantiate()
		elif gooselect == 2:
			goo = orangeGoo.instantiate()
		goo.pos=global_position
		goo.rota=gun.rotation
		get_parent().add_child(goo)
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	if Freeze:
		horizontal_direction = 0
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
