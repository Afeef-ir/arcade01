extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		print("body_entered")
		print(4)
		var current_scene = get_tree().current_scene.scene_file_path
		var next_lvl_num = current_scene.to_int() + 1
		var next_level_path = "res://Levels/level_" + str(next_lvl_num) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
		
		
