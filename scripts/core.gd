extends Node2D

var menu = load("res://scenes/Main_menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
var level_1 = load("res://Levels/level_1.tscn").instantiate()
var level_holder = load("res://Levels/level_holder.tscn").instantiate()
var num = 1

func _ready() -> void:
	add_child(menu)
	menu.connect("start_game", Callable(self,"on_menu_start_game"))
	cut_scene.connect("cut_scene_finished", Callable(self,"on_cut_scene_finished"))
	
	
	
func on_menu_start_game():
	remove_child(menu)
	add_child(cut_scene)

func on_cut_scene_finished():
	remove_child(cut_scene)
	add_child(level_holder)
	

	

	


	
