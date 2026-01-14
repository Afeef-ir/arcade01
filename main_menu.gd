extends Control

signal start_game
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_button_pressed() -> void:
	emit_signal("start_game")

func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	get_tree().quit()
