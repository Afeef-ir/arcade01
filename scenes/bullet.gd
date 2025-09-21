extends CharacterBody2D



@onready var bullet_7: AnimatedSprite2D = $bullet7

@onready var area_2d: Area2D = $Area2D


@onready var Shadow : Sprite2D = $shadow
@onready var RayCast : RayCast2D = $RayCast2D
@onready var explosion: AudioStreamPlayer2D = $explosion
@onready var vanishing: Timer = $vanishing
#@onready var exploding: AudioStreamPlayer2D = %exploding
@onready var disappear: Timer = $disappear
#@onready var exploding: AudioStreamPlayer2D = %exploding
#@onready var bullethit: AudioStreamPlayer2D = $bullethit
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



@export var  deathParticle : PackedScene
var speed : float = 400.0
var travelled_distance = 0





	
	

func _physics_process(delta: float) -> void:
	#bullet_7.play("default")
	global_position += Vector2(1,0).rotated(rotation)* speed *delta
	Shadow.position = Vector2(-2,2).rotated(-rotation)
	var speed = 1000
	const RANGE = 1000
		
	travelled_distance += speed*delta
	if travelled_distance>RANGE:
		
		
		queue_free()
	
	



	



func _on_area_2d_body_entered(body: Node2D) -> void:
	var _particle = deathParticle.instantiate()
	_particle.self_modulate = "blue"
	_particle.lifetime = 2
	_particle.amount = 3
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	speed = 0
	explosion.play()
	bullet_7.play("excplodeeee")
	await bullet_7.animation_finished
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
