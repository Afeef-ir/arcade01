extends Area2D

@export var tag: String = "red" 

#func _ready():
	#connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.has_method("pickup_key"):
		body.pickup_key(tag)
		queue_free()  
