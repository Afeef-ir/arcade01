extends AspectRatioContainer

signal go_back
signal touch_control_toggle(touch_controls)

var touch_controls : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	emit_signal("go_back")


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		if touch_controls == false:
			touch_controls = true
			touch_control_toggle.emit(touch_controls)
	else:
		if touch_controls == true:
			touch_controls = false
			touch_control_toggle.emit(touch_controls)
			

	
