# Bullet

extends Node2D

const RANGE = 1000
const TAKE_DAMAGE_FN = "take_damage"
const DAMAGE:float = 20.0
const burst_fx = preload("res://scenes/burst.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var area_2d: Area2D = $Area2D

@export var explode_sfx : AudioStream

var speed : float = 500.0
var travelled_distance = 0

func _physics_process(delta: float) -> void:
	global_position += Vector2(1,0).rotated(rotation)* speed * delta
	travelled_distance += speed * delta
	if travelled_distance > RANGE:
		queue_free()
	
func destroy() -> void:
	speed = 0
	
	var death_fx_instance = burst_fx.instantiate()
	death_fx_instance.self_modulate = "blue"
	death_fx_instance.lifetime = 2
	death_fx_instance.amount = 3
	death_fx_instance.position = global_position
	death_fx_instance.rotation = global_rotation
	get_tree().current_scene.add_child(death_fx_instance)
	death_fx_instance.play(explode_sfx, 0.5)
	
	sprite.play("explode")
	await sprite.animation_finished
	queue_free()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_method(TAKE_DAMAGE_FN)):
		body.take_damage(DAMAGE)
		
	destroy()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	destroy()
