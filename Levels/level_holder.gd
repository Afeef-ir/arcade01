extends Node2D

@onready var pause_menu: Control = $CanvasLayer/pause_menu
var level_1 = load("res://Levels/level_1.tscn").instantiate()
var menu = load("res://scenes/Main_menu.tscn").instantiate()
var load_level
var loaded_areas : Array = ["1_2", "2_1"]
var to_load : Array = []
var to_unload : Array = []
var loaded_levels : Array = [1]
var t_areas_to_load : Array = []
var t_areas_to_unload : Array = []
var paused : bool = false
func _ready() -> void:
	pause_menu.hide()
	var t1_2 = load("res://T-areas/1_2.tscn").instantiate()
	var t2_1 = load("res://T-areas/2_1.tscn").instantiate()
	add_child(t2_1)
	add_child(level_1)
	add_child(t1_2)
	t1_2.connect("entered",Callable(self,"on_entered"))
	t2_1.connect("entered",Callable(self,"on_entered"))
	#_2_1.connect("entered",Callable(self,"on_entered"))
	
func on_entered(from:int, to:int):
	print("emit success")
	to_load.clear()
	to_unload.clear()
	to_load.append(from)      
	to_unload.append(to)  	
	_load()
	_unload()

func _load():
	for level in to_load:
		if level in loaded_levels:
			pass
		else:
			if ResourceLoader.exists("res://Levels/level_" + str(level)+ ".tscn") :
				var lvl_to_load = load("res://Levels/level_" + str(level)+ ".tscn").instantiate()
				#add_child(lvl_to_load)
				call_deferred("add_child",lvl_to_load)
				loaded_levels.append(level)
				to_load.erase(level)
				load_t_areas(level) 
				load_level = level
				for area in t_areas_to_load:
					if area in loaded_areas:
						print("loaded already" + str(area))
					else:
						loaded_areas.append(area) 
						print("adding area" + str(area))
						if ResourceLoader.exists("res://T-areas/" + area+ ".tscn"):
							print("exists" + str(area))
							var area_instance = load("res://T-areas/" + area+ ".tscn").instantiate()
							call_deferred("add_child",area_instance)
							print(area_instance.name)
							area_instance.connect("entered", Callable(self, "on_entered"))
							
							
func _unload():
	for level in to_unload:
		print("to unload")
		if level in to_load:
			print("needed")
		else:
			if level in loaded_levels:
				print("level loaded, to unload")
				print("Level_" + str(level))
				if has_node("Level" + str(level)):
					print("found node to unload")
					unload_t_areas(level) 
					var unload = get_node("Level" + str(level))
					var areas_needed_at_destination = load_t_areas(load_level) 
					for area in t_areas_to_unload:
						var area_name = str(area.name)
						if area_name in areas_needed_at_destination:
							if area_name not in loaded_areas:
								loaded_areas.append(area_name)
						elif area_name in loaded_areas:
							remove_child(area)
							area.queue_free()
							loaded_areas.erase(area_name)
					remove_child(unload)
					unload.queue_free()
					loaded_levels.erase(level)
				else:
					print("couldnt find node")


func load_t_areas(lvl):
	print("loading ts")
	t_areas_to_load.clear()
	var area_name1 =str(lvl)+ "_"+ str(lvl+1)
	var area_name2 =str(lvl+1)+"_"+ str(lvl)
	t_areas_to_load.append(area_name1)
	t_areas_to_load.append(area_name2)
	if lvl > 1:
		var area_name3 =str(lvl)+"_"+ str(lvl-1)
		var area_name4 =str(lvl-1)+"_"+ str(lvl)
		t_areas_to_load.append(area_name3)
		t_areas_to_load.append(area_name4)
	return t_areas_to_load

func unload_t_areas(lvl):
	t_areas_to_unload.clear()
	print(loaded_areas)
	if has_node(str(lvl) +"_"+ str(lvl+1)):
		var t_area_1 = get_node(str(lvl) +"_"+ str(lvl+1))
		t_areas_to_unload.append(t_area_1)
	if has_node(str(lvl+1) +"_"+ str(lvl)):
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
	return t_areas_to_unload
