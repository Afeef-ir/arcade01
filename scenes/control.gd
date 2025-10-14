extends Control
#
#const TARGET_RATIO = 16.0 / 9.0
#
#func _ready():
	#_update_aspect()
#
#func _notification(what):
	#if what == NOTIFICATION_RESIZED:
		#_update_aspect()
#
#func _update_aspect():
	## Get current window size
	#var window_size_i = DisplayServer.window_get_size()
	#var window_size = Vector2(window_size_i.x, window_size_i.y)
	#
	## Decide maximum height for cutscene (leave space for dialogue)
	#var dialogue_space = 80  # pixels reserved for dialogue box
	#var max_height = window_size.y - dialogue_space
#
	#var window_ratio = window_size.x / max_height
	#var new_size = Vector2()
#
	#if window_ratio > TARGET_RATIO:
		## Window too wide → scale by height
		#new_size.y = max_height
		#new_size.x = max_height * TARGET_RATIO
	#else:
		## Window too tall → scale by width
		#new_size.x = window_size.x
		#new_size.y = window_size.x / TARGET_RATIO
#
	## Center horizontally and vertically above dialogue
	#size = new_size
	#position = Vector2((window_size.x - new_size.x)/2, (max_height - new_size.y)/2)
