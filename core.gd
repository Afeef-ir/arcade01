extends Node2D

var eligible_for_skip = false
var menu = load("res://Main_menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
func _ready() -> void:
	add_child(menu)
	menu.connect("start_game", Callable(self,"on_menu_start_game"))
	
	
	
	
	
func on_menu_start_game():
	remove_child(menu)
	add_child(cut_scene)



	


	
