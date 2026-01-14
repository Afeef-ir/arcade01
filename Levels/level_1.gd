extends Node2D

@onready var portal: Area2D 

func _ready() -> void:
	portal = get_node("Portal")
	portal.connect("change_lvl", Callable(self , "on_change_lvl"))





func on_change_lvl():
	print(4)
	var current_scene = scene_file_path
	var next_lvl_num = current_scene.to_int() + 1
	var next_level_path = "res://Levels/level_" + str(next_lvl_num) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	
