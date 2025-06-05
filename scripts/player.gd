extends CharacterBody2D

@onready var blueGoo = preload("res://scenes/blue_goo_projectile.tscn")
@onready var orangeGoo = preload("res://scenes/orange_goo_projectile.tscn")
@onready var stickyGoo = preload("res://scenes/sticky_goo_projectile.tscn")
@onready var gun = $Gun
@onready var tilemap = $"../MapLayers/Collision"
@onready var gameover = $Camera2D/CanvasLayer/gameover
@onready var hotbar = $Camera2D/CanvasLayer/hotbar
@onready var coyoteTimer = $CoyoteTimer
@onready var gooTimer = $GooTimer
@onready var sprite = $AnimatedSprite2D
@export var maxSpeed = 300
@export var gravity = 30
@export var maxGravity = 700
@export var jumpForce = 600
@export var Freeze = false
@export var accel = 10
@export var airresist = 5

var isDead = false
var gooselect = 0
var lastGoo = 0;
var gooToRemember = 0;
var onLadder = 0;

var blueUnlocked = false;
var orangeUnlocked = false;
var stickyUnlocked = false;

func kill():
	isDead = true
	sprite.hide()
	gun.hide()
	gameover.show() 
	gameover.get_node("retry").grab_focus()
	
func _ready():
	gameover.hide()
	gun.hide()
	hotbar.hide()
	
func entered_ladder():
	onLadder+=1;
	
func exited_ladder():
	onLadder-=1;
	
func pickedUpBlueGun():
	blueUnlocked=true;
	gooselect=1;
	gun.show()
	hotbar.show()
	hotbar.update(1)
	

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
			jumpForce= 600
			
	if is_on_floor():
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
			
		if velocity.x > 0:
			sprite.flip_h = false
		if velocity.x < 0:
			sprite.flip_h = true
			
		if gooTimer.is_stopped(): # not coyote rn so just do normal stuff
			var tilePos = tilemap.local_to_map(tilemap.to_local(position));
			tilePos.y+=1
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
	
	if Input.is_action_pressed("jump") && (is_on_floor() || !coyoteTimer.is_stopped()) && not Freeze:
		velocity.y = -jumpForce
		sprite.play("jump")
		
	if Input.is_action_just_pressed("select_blue") && not Freeze && blueUnlocked:
		gooselect = 1
		hotbar.update(gooselect)
	if Input.is_action_just_pressed("select_orange") && not Freeze && orangeUnlocked:
		gooselect = 2
		hotbar.update(gooselect)
	if Input.is_action_just_pressed("select_sticky") && not Freeze && stickyUnlocked:
		gooselect = 3
		hotbar.update(gooselect)
				
	if Input.is_action_pressed("shoot") && gooselect!=0:
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
	#if Freeze:
		#horizontal_direction = 0
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
	
	var canSticky = false;
	var tilePos = tilemap.local_to_map(tilemap.to_local(position));
	tilePos.x+=1
	if tilemap.get_cell_source_id(tilePos) == 3:
		canSticky=true
	tilePos.x-=99;
	if tilemap.get_cell_source_id(tilePos) == 3:
		canSticky = true

	var vertical_direction = Input.get_axis("move_up", "move_down")
	if canSticky or onLadder>0:
		velocity.y=maxSpeed*vertical_direction
	elif vertical_direction==1:
		position+=Vector2(0,1);
		
	var wasOnFloor = is_on_floor()
	move_and_slide()
	if wasOnFloor && !is_on_floor() && !Input.is_action_pressed("jump"):
		coyoteTimer.start();
