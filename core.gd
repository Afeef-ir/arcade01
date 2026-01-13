extends Node2D

var eligible_for_skip = false
var menu = load("res://scenes/menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
func _ready() -> void:

	add_child(menu)
	menu.connect("start_game", Callable(self, "_on_menu_start_game"))
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skip") and eligible_for_skip:
		skip()

func _on_menu_start_game():
	print("hey")
	remove_child(menu)
	add_child(cut_scene)
	cut_scene.connect("cut_scene_finished", Callable(self, "_on_cut_scene_finished"))
	cut_scene.connect("cut_scene_started", Callable(self, "_on_cut_scene_started"))



	
func _on_cut_scene_finished():
	skip()

	
func _on_cut_scene_started():
	eligible_for_skip = true
func skip():
	remove_child(cut_scene)
	var game = load("res://scenes/game.tscn").instantiate()
	add_child(game)
	
	


	
