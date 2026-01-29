extends AspectRatioContainer

signal go_back
signal touch_control_toggle
signal slider_value_change(value)
signal sfx_slider_value_change(value)

const SAVE_PATH = "user://settings.cfg"
 
var config = ConfigFile.new()
var toggled : bool = false

@onready var check_box: CheckBox = $Settings/CheckBox
@onready var h_slider: HSlider = $Settings/HSlider
@onready var h_slider_2: HSlider = $Settings/HSlider2

func _ready() -> void:
	toggled = false
	load_settings()
	check_box.set_pressed_no_signal(toggled)

func _on_back_pressed() -> void:
	emit_signal("go_back")

func save_settings():
	config.set_value("button","toggled",toggled)
	config.set_value("Audio","bg",h_slider.value)
	config.set_value("Other","sfx",h_slider_2.value)
	config.save(SAVE_PATH)

func load_settings():
	var error = config.load(SAVE_PATH)
	if error != OK:
		return
	toggled = config.get_value("button", "toggled",false)
	if h_slider != null or h_slider_2 != null:
		h_slider.value = config.get_value("Audio","bg",0.6)
		h_slider_2.value = config.get_value("Other","sfx",0.5)
		#if h_slider_2 != null:
		print(h_slider_2.value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	toggled = toggled_on
	save_settings()
	touch_control_toggle.emit()

func _on_h_slider_value_changed(value: float) -> void:
	slider_value_change.emit(value)
	save_settings()

func _on_h_slider_2_value_changed(value: float) -> void:
	sfx_slider_value_change.emit(value)
	save_settings()

func _on_button_pressed() -> void:
	h_slider.value = 0
	save_settings()

func _on_button_2_pressed() -> void:
	h_slider_2.value = 0
	save_settings()
