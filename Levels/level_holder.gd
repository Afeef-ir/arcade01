extends Node2D

@onready var bg_music: AudioStreamPlayer = $BG_music

var level_1 = load("res://Levels/level_1.tscn").instantiate()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(level_1)
	level_1.connect("change", Callable(self, "on_change"))
	#bg_music.play()


func on_change():
	print(6)
	var current_scene = level_1.scene_file_path
	var next_lvl_num = current_scene.to_int() + 1
	var next_level_path = "res://Levels/level_" + str(next_lvl_num) + ".tscn"
	var next_level = load(next_level_path).instantiate()
	level_1.hide()
	remove_child(level_1)
	add_child(next_level)
	level_1 = next_level
	level_1.connect("change", Callable(self, "on_change"))
