extends Node2D

var menu = load("res://scenes/Main_menu.tscn").instantiate()
var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
var level_1 = load("res://Levels/level_1.tscn").instantiate()
var level_holder = load("res://Levels/level_holder.tscn").instantiate()
var num = 1
var touch_value : bool
var audio_bus_id
var music_bus_id

@onready var bg_music: AudioStreamPlayer = $BG_music
var settings = load("res://scenes/settings.tscn").instantiate()



func _ready() -> void:
	AudioServer.add_bus()
	var music_bus = AudioServer.bus_count - 1
	AudioServer.set_bus_name(music_bus, "BGM")
	audio_bus_id = AudioServer.get_bus_index("BGM")
	add_child(menu)
	menu.connect("start_game", Callable(self,"on_menu_start_game"))
	menu.connect("slider_change",Callable(self,"on_slider_change"))
	menu.connect("sfx_change",Callable(self,"on_sfx_change"))
	cut_scene.connect("cut_scene_finished", Callable(self,"on_cut_scene_finished"))
	bg_music.bus= "BGM"
	AudioServer.add_bus(2) 
	AudioServer.set_bus_name(AudioServer.bus_count -1,"Music")
	music_bus_id = AudioServer.get_bus_index("Music")
	
func on_menu_start_game():
	menu.visible = false
	add_child(cut_scene)
	bg_music.stop()
	

func on_cut_scene_finished():
	remove_child(cut_scene)
	add_child(level_holder)
	var pause_menu = get_node("Level_holder").get_node("CanvasLayer").get_node("pause_menu")
	bg_music.play()
	pause_menu.connect("back_to_menu",Callable(self,"on_back_to_menu"))
	pause_menu.connect("slider_change",Callable(self,"on_slider_change"))
	pause_menu.connect("sfx_change",Callable(self,"on_sfx_change"))
	
func on_back_to_menu():
	get_tree().reload_current_scene()
	


func on_slider_change(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id,db)

	
func on_sfx_change(value):
	print("gotit")
	print(value)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_id,db)
	
