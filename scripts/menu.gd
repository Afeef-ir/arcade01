extends Node
signal start_game

func _input(event):
	if event.is_action_pressed("Skip"): 
		print("yes")
		emit_signal("start_game")
