extends CanvasLayer

@export_file("*json") var scene_text_file: String

var scene_text = {}
var selected_text = []
var in_progress = false
@onready var plr = $"../Player"
@onready var background = $Panel
@onready var text_label = $Textlabel

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.connect("display_dialog", Callable(self, "on_display_dialog"))
	
func load_scene_text():
	print(scene_text_file)
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		return test_json_conv.get_data()

func show_text():
	text_label.text = selected_text.pop_front()

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	plr.Freeze = false
	SignalBus.emit_signal("dialog_finished")
	
func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		background.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		plr.Freeze = true
		print(plr.Freeze)
		show_text()
