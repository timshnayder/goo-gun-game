extends CharacterBody2D

@onready var tilemap = $"../TileMapNode/Surfaces"

var pos:Vector2
var rota:float
var speed=50
var gravity=40
var maxGravity=1000


func _ready() -> void:
	position = pos
	velocity=Vector2(speed,0).rotated(rota)
	velocity*=20

func _physics_process(_delta):
	velocity.y+=gravity
	if(velocity.y > maxGravity):
		velocity.y = maxGravity
	
	if is_on_floor():
		var tilePos = tilemap.local_to_map(tilemap.to_local(position));
		tilePos.y+=1;
		tilemap.set_cell(tilePos,1,tilemap.get_cell_atlas_coords(tilePos))
		queue_free()
	if is_on_ceiling():
		var tilePos = tilemap.local_to_map(tilemap.to_local(position));
		tilePos.y-=1;
		tilemap.set_cell(tilePos,1,tilemap.get_cell_atlas_coords(tilePos))
		queue_free()
	if is_on_wall():
		var tilePos = tilemap.local_to_map(tilemap.to_local(position));
		if(velocity.x < 0):
			tilePos.x+=1
		else:
			tilePos.x-=1
		tilemap.set_cell(tilePos,1,tilemap.get_cell_atlas_coords(tilePos))
		queue_free()
	move_and_slide()
