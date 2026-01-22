extends Control


signal start_game


@onready var buttons_holder: VBoxContainer = $Menu/buttons_holder

@onready var aspect_ratio_container: AspectRatioContainer = $Menu/AspectRatioContainer


@onready var menu: Node = $Menu


var gun = load("res://scenes/gun.tscn").instantiate()
var player = load("res://scenes/player.tscn").instantiate()
func _ready() -> void:
	buttons_holder.visible = true
	aspect_ratio_container.visible = true
	player.connect("pause_clicked", Callable(self, "on_pause_clicked"))
	if has_node("Settings"):
		var Settings = get_node("Settings")
		Settings.connect("go_back",Callable(self, "on_go_back"))
		Settings.hide()

func _on_button_pressed() -> void:
	emit_signal("start_game")

func _on_button_2_pressed() -> void:
	menu.hide()
	if has_node("Settings"):
		var Settings = get_node("Settings")
		Settings.show()
	
func _on_button_3_pressed() -> void:
	get_tree().quit()
	
func on_go_back():
	if has_node("Settings"):
		var Settings = get_node("Settings")
		menu.show()
		Settings.hide()







	
