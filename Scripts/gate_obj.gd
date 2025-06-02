extends AnimatableBody2D
@onready var player = $"../../Player"
@onready var animationplr = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var played = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = global_position.distance_to(player.global_position)
	if distance < 150:
		if not played:
			print("h")
			animationplr.play("move")
			played = true
	elif distance > 300:
		if played:
			animationplr.play("close")
			played = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		animationplr.play("keepopen")
	elif anim_name == "close":
		animationplr.play("RESET")
