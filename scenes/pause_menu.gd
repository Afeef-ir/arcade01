extends Control

var paused : bool = false
# Called when the node enters the scene tree for the first time.


signal back_to_menu

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("pause"):
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
	print("emitting")
	emit_signal("back_to_menu")
