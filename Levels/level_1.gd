extends Node2D

signal change

@onready var portal: Area2D 

func _ready() -> void:
	portal = get_node("Portal")
	portal.connect("change_lvl", Callable(self , "on_change_lvl"))





func on_change_lvl():
	print(5)
	emit_signal("change")
	
