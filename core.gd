extends Node2D

var anim_
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
	add_child(cut_scene)
	cut_scene.connect("cutscene_finished", Callable(self, "_on_cutscene_finished"))

func _on_cutscene_finished():
	#if Input.is_action_just_pressed("Skip"):
	print("done")
	var cut_scene = load("res://scenes/Cutscene.tscn").instantiate()
	remove_child(cut_scene)
	var main_scene = load("res://scenes/game.tscn").instantiate()
	add_child(main_scene)
