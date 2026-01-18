extends Node2D

@onready var bg_music: AudioStreamPlayer = $BG_music

var level_1 = load("res://Levels/level_1.tscn").instantiate()
@onready var _1_2: Area2D = $"1-2"


var to_load : Array
var to_unload : Array
var loaded : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_child(level_1)
	level_1.connect("change", Callable(self, "on_change"))
	#bg_music.play()
	_1_2.connect("entered",Callable(self,"on_entered"))

func on_entered(from:int, to:int):
	print("yes")
	print(from)
	print(to)
	to_load.clear()
	to_unload.clear()
	to_load.append(from)
	to_unload.append(to)
	_load_n_unload()






func _load_n_unload():
	for level in to_load:
		var lvl_to_load = load("res://lvl_" + str(level)+ ".tscn").instantiate()
		add_child(lvl_to_load)
		loaded.append(level)
	for level in to_unload:
		var lvl_to_unload = load("res://lvl_" + str(level)+ ".tscn")
		if level in loaded:
			get_node("lvl"+str(level)).queue_free()






#func on_change():
	#print(6)
	#var current_scene = level_1.scene_file_path
	#var next_lvl_num = current_scene.to_int() + 1
	#var next_level_path = "res://Levels/level_" + str(next_lvl_num) + ".tscn"
	#var next_level = load(next_level_path).instantiate()
	#level_1.hide()
	#remove_child(level_1)
	#add_child(next_level)
	#level_1 = next_level
	#level_1.connect("change", Callable(self, "on_change"))
