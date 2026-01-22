extends Control

var paused : bool = false
# Called when the node enters the scene tree for the first time.
@onready var main_pause_menu: MarginContainer = $main_pause_menu
@onready var setting_menu: MarginContainer = $setting_menu


signal back_to_menu

func _ready() -> void:
	main_pause_menu.show()
	setting_menu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("pause"):
		main_pause_menu.show()
		setting_menu.hide()	
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
	print("emitting")
	emit_signal("back_to_menu")


func _on_settings_pressed() -> void:
	main_pause_menu.hide()
	setting_menu.show()


func _on_back_pressed() -> void:
	setting_menu.hide()
	main_pause_menu.show()
