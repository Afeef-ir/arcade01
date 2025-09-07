extends Sprite2D

@onready var Shadow : Sprite2D = $shadow
@onready var RayCast : RayCast2D = $RayCast2D

var speed : float = 1200.0

func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation)* speed *delta
	Shadow.position = Vector2(-2,2).rotated(-rotation)
	
	
