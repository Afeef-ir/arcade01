extends AspectRatioContainer

signal go_back
signal touch_control_toggle

const SAVE_PATH = "user://settings.cfg"
 
var config = ConfigFile.new()
var toggled : bool = false

@onready var check_box: CheckBox = $Settings/CheckBox


func _ready() -> void:
	toggled = false
	load_settings()
	check_box.set_pressed_no_signal(toggled)

func _on_back_pressed() -> void:
	emit_signal("go_back")

func save_settings():
	config.set_value("button","toggled",toggled)
	config.save(SAVE_PATH)

func load_settings():
	var error = config.load(SAVE_PATH)
	if error != OK:
		return
	toggled = config.get_value("button", "toggled",false)


func _on_check_box_toggled(toggled_on: bool) -> void:
	toggled= toggled_on
	save_settings()
	if toggled == true:
		touch_control_toggle.emit()
	else:
		touch_control_toggle.emit()
	
