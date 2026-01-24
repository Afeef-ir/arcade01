extends Control

signal start_game
signal slider_change(value)

@onready var buttons_holder: VBoxContainer = $Menu/buttons_holder
@onready var aspect_ratio_container: AspectRatioContainer = $Menu/AspectRatioContainer
@onready var menu: Node = $Menu

var gun = load("res://scenes/gun.tscn").instantiate()
var player = load("res://scenes/player.tscn").instantiate()

func _ready() -> void:
	buttons_holder.visible = true
	aspect_ratio_container.visible = true
	player.connect("pause_clicked", Callable(self, "on_pause_clicked"))

func _on_button_pressed() -> void:
	emit_signal("start_game")

func _on_button_2_pressed() -> void:
	menu.hide()
	var settings= load("res://scenes/settings.tscn").instantiate()
	settings.connect("go_back",Callable(self,"on_go_back"))
	settings.connect("touch_control_toggle",Callable(self,"on_touch_control_toggled"))
	settings.connect("slider_value_change",Callable(self,"on_value_changed"))
	add_child(settings)
	
func _on_button_3_pressed() -> void:
	get_tree().quit()
	
func on_go_back():
	if has_node("Settings"):
		var sett = get_node("Settings")
		sett.save_settings()
		get_node("Settings").queue_free()
		menu.show()

func on_touch_control_toggled(touch_controls : bool):
	pass

func on_value_changed(value):
	slider_change.emit(value)
	




	
