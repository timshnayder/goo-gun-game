extends CharacterBody2D

@onready var blueGoo = preload("res://scenes/blue_goo_projectile.tscn")
@onready var orangeGoo = preload("res://scenes/orange_goo_projectile.tscn")
@onready var stickyGoo = preload("res://scenes/sticky_goo_projectile.tscn")
@onready var gun = $Gun
@onready var tilemap = $"../TileMapNode/Surfaces"
@onready var gameover = $Camera2D/CanvasLayer/gameover
@onready var sprite = $Sprite2D
@onready var hotbar = $Camera2D/CanvasLayer/hotbar
@onready var coyoteTimer = $CoyoteTimer
@onready var gooTimer = $GooTimer
@export var maxSpeed = 300
@export var gravity = 30
@export var maxGravity = 700
@export var jumpForce = 500

@export var accel = 30
@export var airresist = 5


var isDead = false
var gooselect = 1
var lastGoo = 0;
var gooToRemember = 0;

func kill():
	isDead = true
	sprite.hide()
	gun.hide()
	gameover.show() 
	gameover.get_node("retry").grab_focus()
	print("visible!")
	
func _on_ready():
	print("True")
	gameover.hide()

func _physics_process(delta):
	if isDead: 
		return
		
	if(!gooTimer.is_stopped()): #coyote timer for goo is currently on
		if gooToRemember == 1:
			accel = 10
			maxSpeed = 300
			jumpForce= 1100
		elif gooToRemember == 2:
			accel = 10
			maxSpeed = 600
			jumpForce= 500
			
	if is_on_floor():
		if gooTimer.is_stopped(): # not coyote rn so just do normal stuff
			var tilePos = tilemap.local_to_map(tilemap.to_local(position));
			tilePos.y+=2
			var tileId = tilemap.get_cell_source_id(tilePos)
			if tileId == 0 || tileId == -1: # air or ground
				if lastGoo != 0:
					gooTimer.start()
					gooToRemember = lastGoo
				else:
					accel = 30
					maxSpeed = 300
					jumpForce = 500
				
				lastGoo = 0
				
			if tileId == 1: #blue goo
				accel = 10
				maxSpeed = 300
				jumpForce= 1100
				
				lastGoo = 1
			if tileId == 2: #orange goo
				accel = 10
				maxSpeed = 600
				jumpForce= 500
				
				lastGoo = 2
		
		
	if !is_on_floor():
		velocity.y += gravity
		if(velocity.y > maxGravity):
			velocity.y=maxGravity
	
	if Input.is_action_pressed("jump") && (is_on_floor() || !coyoteTimer.is_stopped()):
		velocity.y = -jumpForce
		
	if Input.is_action_just_pressed("changeL"):
		gooselect -= 1
		if (gooselect < 1):
			gooselect = 3
		hotbar.update(gooselect)
			
	if Input.is_action_just_pressed("changeR"):
		gooselect += 1
		if (gooselect > 3):
			gooselect = 1
		hotbar.update(gooselect)
				
	if Input.is_action_pressed("shoot-blue"):
		var goo = blueGoo.instantiate()
		if gooselect == 1:
			goo = blueGoo.instantiate()
		elif gooselect == 2:
			goo = orangeGoo.instantiate()
		elif gooselect == 3:
			goo = stickyGoo.instantiate()
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
	
	var canSticky = false
	var tilePos = tilemap.local_to_map(tilemap.to_local(position));
	tilePos.x+=2
	var tileId = tilemap.get_cell_source_id(tilePos)
	if tileId == 3:
		canSticky=true
	tilePos.x-=4;
	tileId = tilemap.get_cell_source_id(tilePos)
	if tileId == 3:
		canSticky = true

	var vertical_direction = Input.get_axis("move_up", "move_down")
	if canSticky:
		velocity.y=maxSpeed*vertical_direction

	var wasOnFloor = is_on_floor()
	move_and_slide()
	if wasOnFloor && !is_on_floor() && !Input.is_action_pressed("jump"):
		coyoteTimer.start();
