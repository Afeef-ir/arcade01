extends Node2D

var menu = load("res://scenes/menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
func _ready() -> void:

	add_child(menu)
	menu.connect("start_game", Callable(self, "_on_menu_start_game"))
	
	
func _on_menu_start_game():
	print("hey")
	remove_child(menu)
	add_child(cut_scene)
	cut_scene.connect("cut_scene_finished", Callable(self, "_on_cut_scene_finished"))
	
func _on_cut_scene_finished():
	print("wassup")
	remove_child(cut_scene)
	var game = load("res://scenes/game.tscn").instantiate()
	add_child(game)
	


	
