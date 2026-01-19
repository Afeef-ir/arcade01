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

func _ready() -> void:
	var lvl1 = load("res://lvl_1.tscn").instantiate()
	var t1_2 = load("res://1_2.tscn").instantiate()
	var t2_1 = load("res://2_1.tscn").instantiate()
	add_child(t2_1)
	add_child(lvl1)
	add_child(t1_2)
	#add_child(level_1)
	#level_1.connect("change", Callable(self, "on_change"))
	#bg_music.play()
	t1_2.connect("entered",Callable(self,"on_entered"))
	t2_1.connect("entered",Callable(self,"on_entered"))
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
		print("loading level")
		if level in loaded_levels:
			print(str(level)+ "lvl already loaded")
		else:
			if ResourceLoader.exists("res://lvl_" + str(level)+ ".tscn") :
				var lvl_to_load = load("res://lvl_" + str(level)+ ".tscn").instantiate()
				add_child(lvl_to_load)
				loaded_levels.append(level)
				load_t_areas(level)
				print("loaded level"+ str(level)+ "succesfully")
				to_load.erase(level)
		# ... rest of code
			else:
				print("ERROR: Scene not found!")

	for level in to_unload:
		print("trying to unload" + str(level))
		if level in to_load:
			print("skipped loading" + str(level))
			pass
		else:
			if level in loaded_levels:
				print("  Level is in loaded_levels")
				if has_node("lvl_" + str(level)):
					print("  Found node: ")
					var unload = get_node("lvl_" + str(level))
					remove_child(unload)
					unload.queue_free()
					loaded_levels.erase(level)
					print("  Removed from tree")
					unload_t_areas(level)
				else:
					print("node not found")
			else:
				print("level Not in loaded levels")
			



func load_t_areas(lvl):
	t_areas_to_load.clear()
	var area_name1 =str(lvl)+ "_"+ str(lvl+1)
	var area_name2 =str(lvl+1)+"_"+ str(lvl)
	var area_name3 =str(lvl)+"_"+ str(lvl-1)
	var area_name4 =str(lvl-1)+"_"+ str(lvl)
	t_areas_to_load.append(area_name1)
	t_areas_to_load.append(area_name2)
	t_areas_to_load.append(area_name3)
	t_areas_to_load.append(area_name4)
	for area in t_areas_to_load:
		if not area in loaded_areas:
			print(t_areas_to_load)
			print("Loading new area: ", area)
			var area_instance = load("res://" + area+ ".tscn").instantiate()
			add_child(area_instance)
			loaded_areas.append(area) 
			t_areas_to_load.erase(area)
			var area_node = get_node(area)
			print("Connecting signal for: ", area_instance.name)
			area_instance.connect("entered", Callable(self, "on_entered"))
			print("Signal connected!")
			print(t_areas_to_load)
		else:
			print("area already loaded")

func unload_t_areas(lvl):
	print("    Unloading t_areas for level: ", lvl)
	t_areas_to_unload.clear()
	print("    Looking for: area 1name")
	if has_node(str(lvl) +"_"+ str(lvl+1)):
		print("found")
		var t_area_1 = get_node(str(lvl) +"_"+ str(lvl+1))
		t_areas_to_unload.append(t_area_1)
	if has_node(str(lvl+1) +"_"+ str(lvl)):
		print("found")
		var t_area_2 = get_node(str(lvl+1) +"_"+ str(lvl))
		t_areas_to_unload.append(t_area_2)
		
		
	if lvl==1:
		pass
	else:
		if has_node(str(lvl) +"_"+ str(lvl-1)):
			var t_area_2 = get_node(str(lvl) +"_"+ str(lvl-1))
			t_areas_to_unload.append(t_area_2)
		if has_node(str(lvl-1) +"_"+ str(lvl)):
			var t_area_2 = get_node(str(lvl-1) +"_"+ str(lvl))
			t_areas_to_unload.append(t_area_2)
			
	print("    Total areas to unload: ", t_areas_to_unload.size())
			
	for area in t_areas_to_unload:
		if area.name in loaded_areas:
			if area.name in t_areas_to_load:
				print("    Skipping area (in to_load): "+ str(area))
			else:
				print("removing area"+ str(area))
				remove_child(area)
				loaded_areas.erase(area.name)
		else:
			print("area not in loaded areas")
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
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
