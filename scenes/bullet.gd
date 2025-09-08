extends Sprite2D

@onready var Shadow : Sprite2D = $shadow
@onready var RayCast : RayCast2D = $RayCast2D
@onready var explosion: AudioStreamPlayer2D = $explosion

@export var  deathParticle : PackedScene

var speed : float = 400.0

func _ready() -> void:
	await(get_tree().create_timer(1).timeout)
	
	
func Kill():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	queue_free()
	
func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation)* speed *delta
	Shadow.position = Vector2(-2,2).rotated(-rotation)

	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	Kill()
	
	
	
	
