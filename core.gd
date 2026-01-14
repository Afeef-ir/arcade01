extends Node2D

var eligible_for_skip = false
var menu = load("res://Main_menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
var level_1 = load("res://Levels/level_1.tscn").instantiate()
var portal = load("res://scenes/portal.tscn").instantiate()
var change_lvl_scene : bool = false

func _ready() -> void:
	add_child(menu)
	menu.connect("start_game", Callable(self,"on_menu_start_game"))
	cut_scene.connect("cut_scene_finished", Callable(self,"on_cut_scene_finished"))
	portal.connect("change_lvl", Callable(self, "on_change_lvl"))
	level_1.connect("next_level", Callable(self, "on_next_level"))
	
	
func on_menu_start_game():
	remove_child(menu)
	add_child(cut_scene)

func on_cut_scene_finished():
	remove_child(cut_scene)
	add_child(level_1)
	
#func on_next_level():
	#print(8)
	#change_lvl_scene = true
	#var current_scene = get_child(0).scene_file_path
	#var next_lvl_num = current_scene.to_int() + 1
	#var next_level_path = "res://Levels/level_" + str(next_lvl_num) + ".tscn"
	#var next_lvl = load(next_level_path).instantiate()
	#remove_child(level_1)
	#add_child(next_lvl)
	#
	#print(level_1.scene_file_path)
	

	


	
