extends Area2D

@export var tag: String = "red" 
@export var icon: Texture2D
#func _ready():
	#connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.has_method("pickup_key"):
		body.pickup_key(tag)
	
	if body.has_method("add_key"):
		body.add_key(tag, icon)
	queue_free()  
