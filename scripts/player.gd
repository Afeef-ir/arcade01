extends CharacterBody2D

const SPEED:float = 115.0
const JUMP_VELOCITY:float = -360.0
const WALL_JUMP_VELOCITY:float = 150.0 
const WALL_FACTOR:float = 0.75
const GRAVITY_SCALE:float = 0.7
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.3
const vfx = preload("res://scenes/burst.tscn")

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var hurt_time: Timer = $HurtTime
@onready var slidecol: CollisionShape2D = $SlideCol
@onready var jump: AudioStreamPlayer2D = $JumpSfx
@onready var damage: AudioStreamPlayer2D = $HurtSfx
@onready var hurt_box: Area2D = $HurtBox
@onready var footstep: AudioStreamPlayer2D = $FootStepSfx
@onready var maxHealth = 30
@onready var currentHealth : int = maxHealth
@onready var player: CharacterBody2D = $"."
@onready var deathtimer: Timer = $deathtimer
@onready var camera_2d_2: Camera2D = $Camera2D2
@onready var deathaudio: AudioStreamPlayer2D = $DeathSfx
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wallslide: Timer = $SlideTimer
@onready var thrust_location: Marker2D = $ThrustLocation
@onready var thrust: AudioStreamPlayer2D = $ThrustSfx
@onready var slide: AudioStreamPlayer2D = $SlideSfx
@onready var gun: Node2D = $Gun
@onready var hutcol: CollisionShape2D = $HurtBox/HurtCol
@onready var playercol: CollisionShape2D = $PlayerCol
@onready var slide_pos_r: Marker2D = $SlidePositionR
@onready var slide_pos_l: Marker2D = $SlidePositionL
@onready var slide_time: Timer = $SlideTimer
@onready var timer: Timer = $Timer
@onready var gun_loc_default: Marker2D = $GunLocationDefault
@onready var gun_loc_flipped: Marker2D = $GunLocationFlipped

@export var health_player = 100.0

var knockback_force = Vector2.ZERO
var knockback_time = 0.25
var knockback_upward: float = 200
var is_paused = false
var is_knocked_back: bool = false
var jumps_left:int = 0
var no_input_timer:float = 0.0


		
func _physics_process(delta: float) -> void:
	if is_knocked_back:
		# Move player during knockback
		velocity = knockback_force
		move_and_slide()
		return
	floor_max_angle = deg_to_rad(45)
	floor_snap_length= 8
	if is_on_wall() and is_on_floor():
		pass
	elif player_sprite.animation == "thrust":
		pass
	elif is_on_floor_only():
		pass
	elif is_on_wall():
		pass
	else:
		slide.stop()

	if not is_on_wall_only()  and not is_on_floor_only():
		pass
	else:
		timer.start()
		
	if is_paused:
		return
	
	if is_on_floor():
		slidecol.disabled = true
		jumps_left = MAX_JUMPS
	else: # gravity
		velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at	
	
	if not is_on_wall():
		slide_time.start()
		
	if is_on_wall():
		if is_on_floor():
				slidecol.disabled = true
		
		if is_on_wall_only():
			player_sprite.play("slide")
			slide_time.stop()
			if slide.playing:
				pass
			else:
				slide.play()
			
		if is_on_floor():
			pass
		else:
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)   # get the collision info
				var normal = collision.get_normal()      # get the surface normal (Vector2)
	
	# check direction of wall
			
				if normal.x > 0:
					gun.position = gun_loc_flipped.position
					slidecol.disabled = false
					player_sprite.flip_h=true
					slidecol.position = slide_pos_l.position
				elif normal.x < 0:
					slidecol.disabled = false
					player_sprite.flip_h=false
					slidecol.position = slide_pos_r.position
					gun.position=gun_loc_default.position

		if not is_on_floor_only():
			if Input.is_action_just_pressed("jump"):
				velocity = WALL_JUMP_VELOCITY * get_wall_normal()
				velocity.y += JUMP_VELOCITY
				no_input_timer = NO_INPUT_TIME
			#slide_time.start()
			#timer.start()
			else:
				velocity.y *= WALL_FACTOR
	elif no_input_timer > 0:
		no_input_timer -= delta
	else:
		# Get the input direction for horizontal movement
		var horizontal_input := Input.get_axis("move left" , "move right") # between -1 to 1
		if horizontal_input != 0:
			velocity.x = horizontal_input * SPEED # -SPEED to SPEED
			#d
			if is_on_wall():
				pass
				#player_sprite.play("slide")
			if is_on_floor():
				if not footstep.playing:
					footstep.play()
					player_sprite.play("walk")
				
			if Input.is_action_pressed("fast") and is_on_floor():
				velocity.x *= SPRINT_SCALE
				footstep.pitch_scale= 1.5
			else:
				footstep.pitch_scale = 1
		else: # no horizontal input
			velocity.x = 0.0
			footstep.stop()
			
		if horizontal_input==0 and is_on_floor():
			player_sprite.play("default")
		if horizontal_input == -1:
			player_sprite.flip_h=true
			gunchange()
		
		if horizontal_input == 1:
			player_sprite.flip_h=false
			gun.position = gun_loc_default.position
		if Input.is_action_just_pressed("jump"):
			if jumps_left > 0 and jumps_left<2:
				var _particle = vfx.instantiate()
				_particle.self_modulate = "yellow"
				_particle.emitting = true
				_particle.amount = 75
				_particle.lifetime = 0.5
				_particle.explosiveness = 0
				_particle.modulate.a =12
				#slide_time.start()
				
				get_tree().current_scene.add_child(_particle)
				_particle.global_position = thrust_location.global_position
				_particle.global_rotation = global_rotation
				player_sprite.play("thrust")
				thrust.play()
				
				
				jump.play()
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				footstep.stop()
			if jumps_left>1:
				player_sprite.play("jump")
				jump.play()
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				footstep.stop()
	move_and_slide()
	
func pause():
	is_paused = true
func resume():
	is_paused = false

func _on_hurt_time_timeout() -> void:
	player_sprite.play("default")

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
func apply_knockback(from_position: Vector2, strength: float = 300, upward: float = -200) -> void:
	if is_knocked_back:
		return  # already in knockback
	is_knocked_back = true
	#health_player -= 1
	print("Player damaged! Health:", health_player)
	# Direction away from the enemy
	var dir = (global_position - from_position).normalized()
	# Apply force
	knockback_force = Vector2(dir.x * strength, upward)
	set_deferred("velocity", knockback_force)
	# Short delay before control returns
	await get_tree().create_timer(knockback_time).timeout
	is_knocked_back = false
	print("Knockback from:", from_position, "to:", global_position)
func gunchange():
	if Input.is_action_pressed("move left"):
		gun.position = gun_loc_flipped.position

func _on_slide_time_timeout() -> void:
	player_sprite.play("jump")

func _on_timer_timeout() -> void:
	if player_sprite.animation == "thrust":
		pass 
	else:
		player_sprite.play("jump")


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name.contains("Enemy"):  
		health_player -= 40
		damage.play()
		hurt_time.start()
		%ProgressBar.value = health_player
		animation_player.play("hurt")
		
	if health_player <= 0:
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
		deathaudio.play()
		deathtimer.start()
		set_process(false)
		set_physics_process(false)
