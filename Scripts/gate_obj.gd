extends AnimatableBody2D
@onready var player = $"../../Player"
@onready var animationplr = $CollisionShape2D/AnimationPlayer
@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("dialog_finished", Callable(self, "unlockgate"))

func unlockgate(key):
	if key == "speaker":
		locked = false
	

@export var locked = true
var played = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = global_position.distance_to(player.global_position)
	if distance < 125 && not locked:
		if not played:
			animationplr.play("open")
			sprite.play("open")
			played = true
	elif distance > 175 && not locked:
		if played:
			animationplr.play("close")
			sprite.play("close")
			played = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		animationplr.play("keepopen")
	elif anim_name == "close":
		animationplr.play("RESET")
