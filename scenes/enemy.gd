extends CharacterBody2D

@onready var pathfollow = get_parent()
var direction = 1
const SPEED = 40
@export_enum("loop", "linear") var patrol_type: String = "linear"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
var is_paused = false
var player: CharacterBody2D = null  # To store reference to player

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
				animated_sprite_2d.flip_h = false
				
				direction = 0
			else:
				pathfollow.progress += SPEED*delta
		else:
			if pathfollow.progress_ratio == 0:
				await get_tree().create_timer(0.3).timeout
				animated_sprite_2d.flip_h = true
				#rotation_degrees = lerp(rotation_degrees,0.0,0.1)
				await get_tree().create_timer(0.5).timeout

				direction = 1
			else:
				pathfollow.progress -= SPEED*delta
			
		


#func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	#get_tree().reload_current_scene()





func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player":  # Assuming player node is named "Player"
		player = body
		is_paused = true
		if player.has_method("pause"):
			player.pause()  # Custom pause method in player
			is_paused = true
		timer.start()
	
	



	


func _on_timer_timeout() -> void:
	is_paused = false
	if player and player.has_method("resume"):
		player.resume()  # Custom resume method in player
	get_tree().reload_current_scene()
	is_paused = false 



func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_paused:
		return
	
	queue_free()
