extends AspectRatioContainer

signal go_back
signal touch_control_toggle(touch_controls)

const SAVE_PATH = "user://settings.cfg"
 
var config = ConfigFile.new()
var touch_controls : bool = false
var toggled : bool = false

@onready var check_box: CheckBox = $Settings/CheckBox


func _ready() -> void:
	toggled = false
	load_settings()
	check_box.set_pressed_no_signal(toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	emit_signal("go_back")
	print("emmitied")
			

func save_settings():
	config.set_value("button","toggled",toggled)
	config.save(SAVE_PATH)

func load_settings():
	var error = config.load(SAVE_PATH)
	if error != OK:
		return
	toggled = config.get_value("button", "toggled",false)
	print(toggled)


func _on_check_box_toggled(toggled_on: bool) -> void:
	print("didit")
	toggled= toggled_on
	if toggled_on == true:
		if touch_controls == false:
			touch_controls = true
			touch_control_toggle.emit(touch_controls)
	else:	
		if touch_controls == true:
			touch_controls = false
			touch_control_toggle.emit(touch_controls)
