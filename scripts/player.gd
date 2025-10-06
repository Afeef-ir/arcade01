extends CharacterBody2D

const TINY_NUMBER = 1.0
const SPEED:float = 115.0
const JUMP_VELOCITY:float = -360.0
const WALL_VELOCITY = Vector2(300.0, -300.0)
const WALL_FACTOR:float = 0.25
const GRAVITY_SCALE:float = 0.7
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.3
const MAX_HEALTH = 30
const KNOCKBACK_TIME = 0.25
const FOOTSTEP_VOL = 5.0 * 2
const SLIDE_VOL = 1.0
const vfx = preload("res://scenes/burst.tscn")

@onready var default_col: CollisionShape2D = $PlayerCol
@onready var slide_col: CollisionShape2D = $SlideCol
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var hurt_box: Area2D = $HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var footstep_audio: AudioStreamPlayer2D = $FootStepSfx
@onready var death_audio: AudioStreamPlayer2D = $DeathSfx
@onready var thrust_audio: AudioStreamPlayer2D = $ThrustSfx
@onready var slide_audio: AudioStreamPlayer2D = $SlideSfx
@onready var jump_audio: AudioStreamPlayer2D = $JumpSfx
@onready var damage_audio: AudioStreamPlayer2D = $HurtSfx
@onready var gun: Node2D = $Gun
@onready var death_timer: Timer = $DeathTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var thrust_location: Marker2D = $ThrustLocation
@onready var gun_loc_default: Marker2D = $GunLocationDefault
@onready var gun_loc_flipped: Marker2D = $GunLocationFlipped
@onready var slide_pos_r: Marker2D = $SlidePositionR
@onready var slide_pos_l: Marker2D = $SlidePositionL

var current_health = MAX_HEALTH
var knockback_force = Vector2.ZERO
var knockback_upward: float = 200
var is_paused = false
var is_knocked_back: bool = false
var jumps_left:int = 0
var no_input_timer:float = 0.0
var default_col_pos:Vector2
var default_col_shape:Shape2D

func pause():
	is_paused = true
	
func resume():
	is_paused = false

func _ready() -> void:
	floor_max_angle = deg_to_rad(45)
	floor_snap_length= 8
	#footstep_audio.play()
	#footstep_audio.volume_db=0
	#slide_audio.play()
	#slide_audio.volume_db=0
	default_col_pos = default_col.position
	default_col_shape = default_col.shape
	
func _physics_process(delta: float) -> void:
	
	#resetAudio()
	
	#print(velocity)
	
	if is_paused:
		return

	if is_on_floor() and velocity.x !=0:
		
		footstep_audio.volume_db=FOOTSTEP_VOL 
		if not Input.is_action_just_pressed("fast"):
			
			if footstep_audio.playing == false:
				footstep_audio.playing = true
			
	else:
		#footstep_audio.volume_db=0
		footstep_audio.playing = false
	#if is_on_wall_only():
		#if slide_audio.playing == false:
			#slide_audio.playing = true
		#slide_audio.volume_db = SLIDE_VOL
	#else:
		#slide_audio.volume_db = 0
		#slide_audio.playing = false
	if is_knocked_back:
		# Move player during knockback
		velocity = knockback_force
		move_and_slide()
		return

	if is_on_floor():
		reset_collision()
		jumps_left = MAX_JUMPS
	#elif is_on_wall_only():
		#pass
	else: # gravity
		velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at
	
	if is_on_wall():
		if slide_audio.playing == false:
			slide_audio.playing = true
			slide_audio.volume_db = SLIDE_VOL
			
		if Input.is_action_just_pressed("jump"):
			play_sprite_anim("jump")
			set_horizontal_flip(velocity.x < 0)
			jump_audio.play()
			velocity = WALL_VELOCITY.x * get_wall_normal()
			velocity.y = WALL_VELOCITY.y
			no_input_timer = NO_INPUT_TIME
			reset_collision()
		else:
			
			#slide_audio.volume_db = SLIDE_VOL
			play_sprite_anim("slide")
			set_horizontal_flip(get_wall_normal().x > 0)
			velocity.y *= WALL_FACTOR
			default_col.shape = slide_col.shape
			default_col.position = slide_col.position
				
	elif no_input_timer > 0: # no-input for a bit when wall jumping
		no_input_timer -= delta
		
	else: # regular movement
		slide_audio.volume_db = 0
		slide_audio.playing = false
		var horizontal_input := Input.get_axis("move left" , "move right") # between -1 to 1
		#var horizontal_input := Input.get_axis("move left" , "move right") # between -1 to 1
		if horizontal_input:
			#footstep_audio.play()
			
			velocity.x = horizontal_input * SPEED # -SPEED to SPEED
			set_horizontal_flip(velocity.x < 0)
			
			if is_on_floor():
				if Input.is_action_pressed("fast"):
					velocity.x *= SPRINT_SCALE
					footstep_audio.pitch_scale = 1.5
				else:
					footstep_audio.pitch_scale = 1
					
				var horizontal_speed = abs(velocity.x)
				if horizontal_speed > 0:
					const FEEDBACK_SPEED_FACTOR : float = 0.01
					#footstep_audio.volume_db = FOOTSTEP_VOL * horizontal_speed * FEEDBACK_SPEED_FACTOR
					play_sprite_anim("walk", horizontal_speed * FEEDBACK_SPEED_FACTOR)				
		else:
			if is_on_floor():
				#footstep_audio.stop()
				pass
			velocity.x = 0.0
			
		if is_on_floor() and abs(velocity.x) < TINY_NUMBER:
			play_sprite_anim("default")
			
				
		if Input.is_action_just_pressed("jump") and jumps_left > 0:
			#resetAudio()
			footstep_audio.volume_db = 0.0
			if jumps_left > 1: # not the final jump
				play_sprite_anim("jump")
				jump_audio.play()
			else: # thruster
				play_sprite_anim("thrust")
				var _particle = vfx.instantiate()
				_particle.self_modulate = "yellow"
				_particle.emitting = true
				_particle.amount = 75
				_particle.lifetime = 0.5
				_particle.explosiveness = 0
				_particle.modulate.a =12
				get_tree().current_scene.add_child(_particle)
				_particle.global_position = thrust_location.global_position
				_particle.global_rotation = global_rotation
				thrust_audio.play()
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
				
	move_and_slide()

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
func reset_collision() -> void:
	default_col.shape = default_col_shape
	default_col.position = default_col_pos
	
#func resetAudio() -> void:
	#slide_audio.volume_db = 0.0
	#footstep_audio.volume_db = 0.0
	
func apply_knockback(from_position: Vector2, strength: float = 300, upward: float = -200) -> void:
	if is_knocked_back:
		return  # already in knockback
	is_knocked_back = true
	#current_health -= 1
	print("Player damaged! Health:", current_health)
	# Direction away from the enemy
	var dir = (global_position - from_position).normalized()
	# Apply force
	knockback_force = Vector2(dir.x * strength, upward)
	set_deferred("velocity", knockback_force)
	# Short delay before control returns
	await get_tree().create_timer(KNOCKBACK_TIME).timeout
	is_knocked_back = false
	print("Knockback from:", from_position, "to:", global_position)
	
func set_horizontal_flip(value:bool):
	player_sprite.flip_h = value
	if player_sprite.flip_h:
		gun.position = gun_loc_flipped.position
	else:
		gun.position = gun_loc_default.position
		
func play_sprite_anim(anim_name:String, speed:float = 1.0, reverse:bool = false):
	if player_sprite.get_animation() == anim_name and (player_sprite.is_playing() || abs(player_sprite.get_playing_speed() - speed) > TINY_NUMBER):
		return
	player_sprite.speed_scale = speed
	player_sprite.play(anim_name, 1.0, reverse)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name.contains("Enemy"):  
		current_health -= 40
		damage_audio.play()
		hurt_timer.start()
		%ProgressBar.value = current_health
		animation_player.play("hurt")
		await(hurt_timer.timeout)
		animation_player.stop()
		
	if current_health <= 0:
		player_sprite.hide()
		gun.hide()
		velocity.y=0
		velocity.x=0
		var _particle = vfx.instantiate()
		_particle.position = global_position
		_particle.rotation = global_rotation
		_particle.self_modulate = "orange"
		_particle.emitting = true
		_particle.amount = 100
		get_tree().current_scene.add_child(_particle)
		death_audio.play()
		death_timer.start()
		set_process(false)
		set_physics_process(false)
