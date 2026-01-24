extends Node2D

var menu = load("res://scenes/Main_menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
var level_1 = load("res://Levels/level_1.tscn").instantiate()
var level_holder = load("res://Levels/level_holder.tscn").instantiate()
var num = 1
var touch_value : bool
@onready var bg_music: AudioStreamPlayer = $BG_music




func _ready() -> void:
	add_child(menu)
	menu.connect("start_game", Callable(self,"on_menu_start_game"))
	cut_scene.connect("cut_scene_finished", Callable(self,"on_cut_scene_finished"))
	bg_music.play()

func on_menu_start_game():
	menu.visible = false
	add_child(cut_scene)
	bg_music.stop()
	

func on_cut_scene_finished():
	bg_music.play()
	remove_child(cut_scene)
	add_child(level_holder)
	var pause_menu = get_node("Level_holder").get_node("CanvasLayer").get_node("pause_menu")
	pause_menu.connect("back_to_menu",Callable(self,"on_back_to_menu"))


	
func on_back_to_menu():
	get_tree().reload_current_scene()
	

	


	
