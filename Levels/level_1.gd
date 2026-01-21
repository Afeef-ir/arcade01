extends Node2D

signal change

@onready var portal: Area2D 

func _ready() -> void:
	print("checking")
	if get_parent().has_node("Player"):
		print("has")
		var player = get_parent().get_node("Player")
		player.spawn_position =  player.position






func on_change_lvl():
	print(5)
	emit_signal("change")
	
