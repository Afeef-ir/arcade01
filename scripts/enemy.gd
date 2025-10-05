extends CharacterBody2D

const burst = preload("res://scenes/burst.tscn")
const ERROR_SQ = 400.0 # 20

@export var enemy_health : float
@export_enum("loop", "linear") var patrol_type: String = "linear"
@export var death_audio : AudioStream
@export var speed : float = 300
@export var patrol_points : Array[Vector2] = []

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSfx
@onready var hurt_timer: Timer = $HurtTimer
@onready var timer: Timer = $Timer
@onready var hurt_anim: AnimationPlayer = $HurtAnim
@onready var path_follow = get_parent()

var is_paused = false
var player: CharacterBody2D = null
var patrol_target : Vector2
var patrol_index : int = 0

func _ready() -> void:
	patrol_target = patrol_points[patrol_index]
	
func _physics_process(delta: float) -> void:
	if is_paused:
		return  # Skip processing while paused
		
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	var difference : Vector2 = patrol_target - global_position
	#print(difference.length_squared())
	if difference.length_squared() > ERROR_SQ:
		var patrol_velocity = difference.normalized() * speed
		velocity.x = patrol_velocity.x
		sprite.flip_h = velocity.x < 0
	else:
		patrol_index = (patrol_index+1) % patrol_points.size()
		patrol_target = patrol_points[patrol_index]
	
	move_and_slide()

func take_damage(damage_val:float) -> void:
	enemy_health -= damage_val
	hurt_sfx.play()
	hurt_timer.start()
	hurt_anim.play("Hurt")
	# Start looping Animationaaaaaaaa
	
	if enemy_health <= 0:
		var death_fx = burst.instantiate()
		death_fx.self_modulate = "orange"
		death_fx.position = global_position
		death_fx.rotation = global_rotation
		death_fx.amount = 60
		get_tree().current_scene.add_child(death_fx)
		death_fx.play(death_audio, 0.5)
		
		sprite.queue_free()
		queue_free()

func _on_hurt_timer_timeout() -> void:
	hurt_anim.stop()

#func _on_hurt_box_body_entered(body) -> void:
	#if body.is_in_group("player"):
		#body.apply_knockback(global_position)


func _on_enemy_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.apply_knockback(global_position)
