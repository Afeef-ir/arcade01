extends Node2D

@onready var bg_music: AudioStreamPlayer = $BG_music

var level_1 = load("res://Levels/level_1.tscn").instantiate()
@onready var _1_2: Area2D = $"1-2"

var loaded_areas : Array = [load("res://1_2.tscn").instantiate(), load("res://2_1.tscn").instantiate()]
var to_load : Array
var to_unload : Array
var loaded_levels : Array = [1]
var t_areas_to_load : Array
var t_areas_to_unload : Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_child(level_1)
	#level_1.connect("change", Callable(self, "on_change"))
	#bg_music.play()
	_1_2.connect("entered",Callable(self,"on_entered"))

func on_entered(from:int, to:int):
	print("emit_succes")
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
		loaded_levels.append(level)
		load_t_areas(level)
	for level in to_unload:
		if level in to_load:
			pass
		else:
			if level in loaded_levels:
				var unload = get_node("lvl_1")
				remove_child(unload)
				unload_t_areas(level)
			



func load_t_areas(lvl):

	
	var t_area_1 = load("res://" + str(lvl)+"_"+ str(lvl + 1)+ ".tscn").instantiate()
	var t_area_2 = load("res://" + str(lvl+1)+"_"+ str(lvl)+ ".tscn").instantiate()
	t_areas_to_load.append(t_area_1)
	t_areas_to_load.append(t_area_2)
	if lvl>1:
		var t_area_3 = load("res://" + str(lvl)+"_"+ str(lvl - 1)+ ".tscn").instantiate()
		var t_area_4 = load("res://" + str(lvl-1)+"_"+ str(lvl)+ ".tscn").instantiate()
		t_areas_to_load.append(t_area_3)
		t_areas_to_load.append(t_area_4)
	for area in t_areas_to_load:
		if area in loaded_areas:
			pass
		else:
			add_child(area)
			loaded_areas.append(area)
			area.connect("entered",Callable(self,"on_entered"))

func unload_t_areas(lvl):
	var t_area_1 = get_node(str(lvl) +"-"+ str(lvl+1))
	var t_area_2 = get_node(str(lvl+1) + "-"+str(lvl))
	t_areas_to_unload.append(t_area_1)
	t_areas_to_unload.append(t_area_2)
	if lvl>1:
		var t_area_3 = get_node(str(lvl) +"-"+ str(lvl-1))
		var t_area_4 = get_node(str(lvl-1) +"-"+ str(lvl))
		t_areas_to_unload.append(t_area_3)
		t_areas_to_unload.append(t_area_4)
	for area in t_areas_to_unload:
		var area_path = load(area.scene_file_path).instantiate()
		if area_path in loaded_areas:
			if area_path in t_areas_to_load:
				pass
			else:
				remove_child(area)
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
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
