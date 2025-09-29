extends CharacterBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var enemy_health : float
@onready var pathfollow = get_parent()
var direction = 1
const SPEED = 40
@export_enum("loop", "linear") var patrol_type: String = "linear"
@export var  deathParticle : PackedScene
@onready var timer: Timer = $Timer
var is_paused = false
var player: CharacterBody2D = null  # To store reference to player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var e_nemy_damge: AudioStreamPlayer2D = $ENemyDamge
@onready var hurt_enemy: Timer = $Hurt_enemy
const burst = preload("res://burst.tscn")
#const JUMP_VELOCITY = -400.0
#
#
func _physics_process(delta: float) -> void:
	if is_paused:
		return  # Skip processing while paused
	patrol(delta)
	
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

func patrol(delta):
	if patrol_type == "loop":
		pathfollow.progress+= SPEED * delta
		if rotation_degrees != 0:
			rotation_degrees = lerp(rotation_degrees, 0.0, 0.1)

	else:
		if direction == 1:
			if pathfollow.progress_ratio == 1:
				await get_tree().create_timer(0.3).timeout
				#rotation_degrees = lerp(rotation_degrees,180.0,0.1)
				await get_tree().create_timer(0.5).timeout
				animated_sprite_2d.flip_h = true
				
				direction = 0
			else:
				pathfollow.progress += SPEED*delta
		else:
			if pathfollow.progress_ratio == 0:
				await get_tree().create_timer(0.3).timeout
				animated_sprite_2d.flip_h = false
				#rotation_degrees = lerp(rotation_degrees,0.0,0.1)
				await get_tree().create_timer(0.5).timeout

				direction = 1
			else:
				pathfollow.progress -= SPEED*delta
			
		


#func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	#get_tree().reload_current_scene()




#
#func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	#if body.name == "player":  # Assuming player node is named "Player"
		#player = body
		#is_paused = true
		#if player.has_method("pause"):
			#player.pause()  # Custom pause method in player
			#is_paused = true
		#timer.start()
	
	



	


	



#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if is_paused:
		#return
	#
	#var _particle = deathParticle.instantiate()
#
	#
	#
	#_particle.position = global_position
	#_particle.rotation = global_rotation
	#_particle.emitting = true
	#get_tree().current_scene.add_child(_particle)
	#queue_free()
	#audio_stream_player_2d.play()
	#await audio_stream_player_2d.finished
	#queue_free()
	
	


func _on_enemy_area_entered(area:Area2D) -> void:
	
	enemy_health -= 20
	e_nemy_damge.play()
	hurt_enemy.start()
	animated_sprite_2d.play("Hurt_enemy")
	
	
	
	#var _particle = deathParticle.instantiate()
#
	#
	#
	#_particle.position = global_position
	#_particle.rotation = global_rotation
	#_particle.emitting = true
	#get_tree().current_scene.add_child(_particle)
	#queue_free()
	#audio_stream_player_2d.play()
	#await audio_stream_player_2d.finished
	#queue_free()
	if enemy_health<=0:
		var _particle = deathParticle.instantiate()
		var sound =burst.instantiate()
		sound.global_position= animated_sprite_2d.global_position
		get_tree().current_scene.add_child(sound)
		sound.play()
		
		
		_particle.position = global_position
		_particle.rotation = global_rotation
		_particle.emitting = true
		get_tree().current_scene.add_child(_particle)
		animated_sprite_2d.queue_free()
		audio_stream_player_2d.play()
		queue_free()
		
	
#func _on_enemy_body_entered(body: CharacterBody2D) -> void:
	#var _particle = deathParticle.instantiate()
#
	#
	#
	#_particle.position = global_position
	#_particle.rotation = global_rotation
	#_particle.emitting = true
	#get_tree().current_scene.add_child(_particle)
	#queue_free()
	#audio_stream_player_2d.play()
	#await audio_stream_player_2d.finished
	#queue_free()


func _on_hurt_enemy_timeout() -> void:
	animated_sprite_2d.play("default")


func _on_enemy_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.apply_knockback(global_position)
		print("Hit player!")  # check the output
