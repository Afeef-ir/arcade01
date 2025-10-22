extends CharacterBody2D

const burst = preload("res://scenes/burst.tscn")
const ERROR_SQ = 400.0 # 20
const max_distance = 200

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
@onready var detector_col: CollisionShape2D = $Detector/Detector_col
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var raycast_pos_2: Marker2D = $RaycastPos2
@onready var raycast_pos_1: Marker2D = $RaycastPos1


var is_paused = false
var player
var patrol_target : Vector2
var patrol_index : int = 0
var current_state : State
enum State 
{
	Patrol,
	Chase
}

func _ready() -> void:
	patrol_target = patrol_points[patrol_index]
	player = get_tree().get_first_node_in_group("Player")
	enter_state(State.Patrol)
	
func enter_state(new_state: State):
	exit_state(current_state)
	current_state = new_state
	match State:
		State.Patrol:
			pass
		State.Chase:
			detector_col.disabled = false


	
func exit_state(old_state: State):
	match old_state:
		State.Patrol:
			pass
			#detector_col.disabled = true
		State.Chase:
			detector_col.disabled = false

func _physics_process(delta: float) -> void:
	
	
	if is_paused:
		return  # Skip processing while paused
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if not ray_cast_2d.is_colliding() and is_on_floor():
		
		velocity.x = 0
		print("hi")
	if sprite.flip_h:
		ray_cast_2d.global_position = raycast_pos_2.global_position
	else:
		ray_cast_2d.global_position = raycast_pos_1.global_position
	match current_state:
		State.Patrol:
			var difference : Vector2 = patrol_target - global_position
			#print(difference.length_squared())
			if difference.length_squared() > ERROR_SQ:
				var patrol_velocity = difference.normalized() * speed
				velocity.x = patrol_velocity.x
				sprite.flip_h = velocity.x >0
			else:
				patrol_index = (patrol_index+1) % patrol_points.size()
				patrol_target = patrol_points[patrol_index]
		State.Chase:
			var player_pos = player.global_position
			if abs(player_pos.x - global_position.x) >max_distance:
				enter_state(State.Patrol)
			sprite.flip_h = velocity.x >0
			var velocity_y = (player_pos -global_position).normalized()* speed
			velocity.x = velocity_y.x
			if ray_cast_2d.is_colliding():
				pass
			else:
				velocity.x = -1
			sprite.flip_h = player_pos.x-global_position.x > 0
	#sprite.speed_scale =clamp(speed, 0.5, 3.0) 

func take_damage(damage_val:float) -> void:
	enemy_health -= damage_val
	hurt_sfx.play()
	hurt_timer.start()
	hurt_anim.play("Hurt")
	# Start looping Animationaaaaaaaa
	
	if enemy_health <= 0:
		var death_fx = burst.instantiate()
		death_fx.self_modulate = "gray"
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


func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enter_state(State.Chase)
