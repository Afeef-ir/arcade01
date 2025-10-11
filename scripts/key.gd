extends Area2D

@export var tag: String = "red" 
@export var icon: Texture2D

@onready var key_collect: AudioStreamPlayer2D = $KeyCollect

func _on_body_entered(body):
	key_collect.play()
	if body.has_method("pickup_key"):
		body.pickup_key(tag, icon)
		hide()
		await get_tree().create_timer(1).timeout
		queue_free()  
