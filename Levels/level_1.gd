extends Node2D

signal change

@onready var portal: Area2D 

func _ready() -> void:
	var player = get_parent().get_node("player")
	player.spawn_position =  player.position






func on_change_lvl():
	print(5)
	emit_signal("change")
	
