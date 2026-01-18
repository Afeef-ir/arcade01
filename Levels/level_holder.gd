extends Node2D

@onready var bg_music: AudioStreamPlayer = $BG_music

var level_1 = load("res://Levels/level_1.tscn").instantiate()
@onready var _1_2: Area2D = $"1_2"



var loaded_areas : Array = ["1_2"]
var to_load : Array = []
var to_unload : Array = []
var loaded_levels : Array = [1]
var t_areas_to_load : Array = []
var t_areas_to_unload : Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lvl1 = load("res://lvl_1.tscn").instantiate()
	var t1_2 = load("res://1_2.tscn").instantiate()
	add_child(lvl1)
	add_child(t1_2)
	#add_child(level_1)
	#level_1.connect("change", Callable(self, "on_change"))
	#bg_music.play()
	t1_2.connect("entered",Callable(self,"on_entered"))
	#_2_1.connect("entered",Callable(self,"on_entered"))
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
		if ResourceLoader.exists("res://lvl_" + str(level)+ ".tscn"):
			var lvl_to_load = load("res://lvl_" + str(level)+ ".tscn").instantiate()
			add_child(lvl_to_load)
			loaded_levels.append(level)
			load_t_areas(level)
	# ... rest of code
		else:
			print("ERROR: Scene not found!")

	for level in to_unload:
		if level in to_load:
			pass
		else:
			if level in loaded_levels:
				if has_node("lvl_" + str(level)):
					var unload = get_node("lvl_" + str(level))
					remove_child(unload)
					unload.queue_free()
					loaded_levels.erase(level)
					unload_t_areas(level)
			



func load_t_areas(lvl):
	t_areas_to_load.clear()
	var area_name1 =str(lvl)+ "_"+ str(lvl+1)
	var area_name2 =str(lvl+1)+"_"+ str(lvl)
	var area_name3 =str(lvl)+"_"+ str(lvl-1)
	var area_name4 =str(lvl-1)+"_"+ str(lvl)
	t_areas_to_load.append(area_name1)
	t_areas_to_load.append(area_name2)
	if lvl>1:
		t_areas_to_load.append(area_name3)
		t_areas_to_load.append(area_name4)
	for area in t_areas_to_load:
		if area in loaded_areas:
			print("Area already loaded: ", area)
		else:
			print("Loading new area: ", area)
			var area_instance = load("res://" + area+ ".tscn").instantiate()
			add_child(area_instance)
			loaded_areas.append(area)  # Store the name string
			var area_node = get_node(area)
			print("Connecting signal for: ", area_instance.name)
			area_instance.connect("entered", Callable(self, "on_entered"))
			print("Signal connected!")

func unload_t_areas(lvl):
	t_areas_to_unload.clear()
	if has_node(str(lvl) +"_"+ str(lvl+1)):
		var t_area_1 = get_node(str(lvl) +"_"+ str(lvl+1))
		t_areas_to_unload.append(t_area_1)
	if has_node(str(lvl) +"_"+ str(lvl+1)):
		var t_area_2 = get_node(str(lvl) +"_"+ str(lvl+1))
		t_areas_to_unload.append(t_area_2)
		
		
	if lvl>1:
		if has_node(str(lvl) +"_"+ str(lvl+1)):
			var t_area_2 = get_node(str(lvl) +"_"+ str(lvl+1))
			t_areas_to_unload.append(t_area_2)
		if has_node(str(lvl) +"_"+ str(lvl+1)):
			var t_area_2 = get_node(str(lvl) +"_"+ str(lvl+1))
			t_areas_to_unload.append(t_area_2)
	for area in t_areas_to_unload:
		if area.name in loaded_areas:
			if area.name in t_areas_to_load:
				pass
			else:
				remove_child(area)
				loaded_areas.erase(area.name)
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
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
