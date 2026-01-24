extends Control

@onready var main_pause_menu: MarginContainer = $main_pause_menu

var paused : bool = false
var settings = load("res://scenes/settings.tscn").instantiate()

signal back_to_menu
signal enable_or_disable_touch

func _ready() -> void:
	main_pause_menu.show()
	settings.connect("go_back",Callable(self,"on_go_back"))
	settings.connect("touch_control_toggle",Callable(self,"on_toggled"))

func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("pause"):
		main_pause_menu.show()
		pause_game()
		
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
	settings.connect("go_back",Callable(self,"on_go_back"))
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
