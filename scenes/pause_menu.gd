extends Control

@onready var main_pause_menu: MarginContainer = $main_pause_menu

var paused : bool = false
var settings = load("res://scenes/settings.tscn").instantiate()
var control
signal slider_change(value)
signal back_to_menu
signal enable_or_disable_touch
signal sfx_change(value)

func _ready() -> void:
	main_pause_menu.show()
	settings.connect("go_back",Callable(self,"on_go_back"))
	settings.connect("touch_control_toggle",Callable(self,"on_toggled"))
	settings.connect("slider_value_change",Callable(self,"on_value_changed"))
	settings.connect("sfx_slider_value_change",Callable(self,"on_sfx_slider_value_change"))
	control = get_parent().get_parent().get_node("Player/player_hud/Control")
	control.connect("pressed",Callable(self,"on_show"))
	print(control.name)

func pause_game():
	if paused:
		visible = false
		get_tree().paused = false
	else:
		visible = true
		get_tree().paused = true
	paused = !paused


func _on_resume_pressed() -> void:
	pause_game()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	emit_signal("back_to_menu")


func _on_settings_pressed() -> void:
	main_pause_menu.hide()
	add_child(settings)
	settings.show()


func _on_back_pressed() -> void:
	#setting_menu.hide()
	main_pause_menu.show()
	
func on_go_back():
	var sett = get_node("Settings")
	sett.save_settings()
	remove_child(sett)
	main_pause_menu.show()

func on_toggled():
	emit_signal("enable_or_disable_touch")
	settings.save_settings()

func on_value_changed(value):
	slider_change.emit(value)
	
func on_sfx_slider_value_change(value):
	sfx_change.emit(value)
	
func on_show():
	print(3)
	main_pause_menu.show()
	pause_game()
