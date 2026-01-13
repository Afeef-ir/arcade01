extends Area2D


@export var health_contained : int = 80
@onready var pick_up_sfx: AudioStreamPlayer = $Pick_up_sfx
@onready var sprite_2d: Sprite2D = $Sprite2D
var usable = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_script() 
		if body.current_health < 100 and usable:
			body.current_health += health_contained
			pick_up_sfx.play()
			sprite_2d.hide()
			usable = false
			await get_tree().create_timer(1).timeout
			queue_free()
	
