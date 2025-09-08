extends Sprite2D


@export var  deathParticle : PackedScene



func _ready() -> void:
	await(get_tree().create_timer(1).timeout)
	Kill()
	
func Kill():
	var _particle = deathParticle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emmiting = true
	get_tree().current_scene.add_child(_particle)
	queue_free()
	
