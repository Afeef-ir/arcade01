extends CharacterBody2D

enum State
{
	Idle,
	Walking,
	Falling,
	Sliding
}

const TINY_NUMBER = 0.1
const SPEED:float = 115.0
const JUMP_VELOCITY = Vector2(0.0, -360.0)
const JUMP_OFFSET:float = -5.0
const WALL_OFFSET:float = 20.0
const WALL_VELOCITY = Vector2(270.0, -250.0)
const WALL_SPEED_FACTOR:float = 0.75
const GRAVITY_SCALE:float = 0.7
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.3
const MAX_HEALTH = 100
const KNOCKBACK_TIME = 0.25
const COLLISION_OFFSET = Vector2(0, -16)
const vfx = preload("res://scenes/burst.tscn")
const KEY_UI_SCENE := preload("res://scenes/KeyUI.tscn")

signal key_picked(tag)
signal key_used(tag, remaining)

@onready var keys_container: HBoxContainer = $CanvasLayer/KeyContainer
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
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect

var current_health = MAX_HEALTH
var knockback_force = Vector2.ZERO
var knockback_upward: float = 200
var is_paused = false
var is_knocked_back: bool = false
var jumps_left:int = 0
var no_input_timer:float = 0.0
var default_col_pos:Vector2
var default_col_shape:Shape2D
var spawn_position = Vector2.ZERO
var collected_keys: Array[String] = []
var current_state: State

func pause():
	is_paused = true
	
func resume():
	is_paused = false

func _ready() -> void:
  # 1️⃣ Create the gradient data
	var grad = Gradient.new()
	grad.colors = [Color(0.1,0.1,0.1), Color(0.2,0.2,0.2)]
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = grad
	texture_rect.texture = gradient_texture
	
	floor_max_angle = deg_to_rad(45)
	floor_snap_length = 8
	wall_min_slide_angle = 9
	
	default_col_pos = default_col.position
	default_col_shape = default_col.shape
	spawn_position = global_position
	
	for child in keys_container.get_children():
		keys_container.remove_child(child)
		
	enter_state(State.Idle) # initialize
		
func apply_gravity(delta:float):
	velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at
	
func enter_state(new_state: State):
	exit_state(current_state)
	current_state = new_state
	#print("entered state:" + State.keys()[current_state])	
	match current_state:
		State.Idle:
			jumps_left = MAX_JUMPS
			velocity = Vector2.ZERO
			play_sprite_anim("default")
		State.Walking:
			footstep_audio.playing = true
		State.Falling:
			jumps_left -= 1
			play_sprite_anim("jump")
		State.Sliding:
			jumps_left = MAX_JUMPS
			default_col.shape = slide_col.shape
			default_col.position = slide_col.position
			slide_audio.playing = true
			play_sprite_anim("slide")
		
func exit_state(old_state: State):
	match old_state:
		State.Idle:
			pass
		State.Walking:
			footstep_audio.playing = false
		State.Falling:
			pass
		State.Sliding:
			reset_collision()
			slide_audio.playing = false
			
func try_jump(jump_velocity:Vector2) -> bool:
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		jump_audio.play()
		velocity = jump_velocity
		position.y += JUMP_OFFSET
		enter_state(State.Falling)
		return true
	return false
	
func _physics_process(delta: float) -> void:	
	if is_paused:
		footstep_audio.playing = false
		slide_audio.playing = false
		return
		
	if is_knocked_back:
		velocity = knockback_force
		move_and_slide()
		return
	
	no_input_timer -= delta
	if no_input_timer > 0:
		move_and_slide()
		return
		
	#print(velocity)
	var horizontal_input := Input.get_axis("move left" , "move right") # between -1 to 1
	
	# update state
	match current_state:
		State.Idle:
			if is_on_floor():
				if horizontal_input:
					enter_state(State.Walking)
				else:
					try_jump(JUMP_VELOCITY)
			else:	
				enter_state(State.Falling)

		State.Walking:
			if is_on_floor(): # update
				if not try_jump(JUMP_VELOCITY):
					if horizontal_input: # ground control
						velocity.x = horizontal_input * SPEED # -SPEED to SPEED
						set_horizontal_flip(velocity.x < 0) # set flip only on input
						
						if Input.is_action_pressed("fast"):
							velocity.x *= SPRINT_SCALE
						
						var horizontal_speed = abs(velocity.x)
						const SPEED_FEEDBACK_FACTOR = 0.0075
						footstep_audio.pitch_scale = horizontal_speed * SPEED_FEEDBACK_FACTOR
						play_sprite_anim("walk", horizontal_speed * SPEED_FEEDBACK_FACTOR)
					else:
						enter_state(State.Idle)
			elif not is_on_wall():
				enter_state(State.Falling)

		State.Falling:
			if is_on_floor():
				enter_state(State.Idle)
			elif is_on_wall_only():
				enter_state(State.Sliding)
			else: # update
				if horizontal_input: # air or ground control
					velocity.x = horizontal_input * SPEED # -SPEED to SPEED
					set_horizontal_flip(velocity.x < 0) # set flip only on input
					
				if try_jump(JUMP_VELOCITY):
					jumps_left -= 1
					play_sprite_anim("thrust")
					var _particle = vfx.instantiate()
					_particle.self_modulate = "yellow"
					_particle.emitting = true
					_particle.amount = 75
					_particle.lifetime = 0.5
					_particle.explosiveness = 0
					_particle.modulate.a = 12
					get_tree().current_scene.add_child(_particle)
					_particle.global_position = thrust_location.global_position
					_particle.global_rotation = global_rotation
					thrust_audio.play()
				else:
					apply_gravity(delta)

		State.Sliding:
			if is_on_floor():
				position.x -= WALL_OFFSET * get_wall_normal().x
				enter_state(State.Idle)
			elif is_on_wall():
				set_horizontal_flip(get_wall_normal().x > 0)
				var jump_velocity = WALL_VELOCITY.x * get_wall_normal() # right or left
				jump_velocity.y = WALL_VELOCITY.y # always go up
				if try_jump(jump_velocity):
					no_input_timer = NO_INPUT_TIME
				else:
					apply_gravity(delta)
					velocity.y *= WALL_SPEED_FACTOR
			else:
				enter_state(State.Falling)
					
	move_and_slide()

func _on_death_timer_timeout() -> void:
	respawn()
	
func reset_collision() -> void:
	default_col.shape = default_col_shape
	default_col.position = default_col_pos
	position += COLLISION_OFFSET  # shift because of collision size diff
	
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
	if player_sprite.get_animation() == anim_name and player_sprite.is_playing() and abs(player_sprite.get_playing_speed() - speed) < TINY_NUMBER:
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
	
func respawn():
	global_position = spawn_position
	current_health= MAX_HEALTH
	#velocity = Vector2.ZERO
	player_sprite.show()
	gun.show()  
	set_process(true)
	set_physics_process(true)
	progress_bar.value =MAX_HEALTH
	
func pickup_key(tag: String, icon: Texture2D) -> void:
	if tag in collected_keys:
		return
		
	collected_keys.append(tag)
	_add_key_to_ui(tag, icon)
		
	emit_signal("key_picked", tag)
	print("Picked key:", tag)

func has_key(tag: String) -> bool:
	return collected_keys.find(tag) != -1

func use_key(tag: String) -> bool:
	if has_key(tag):
		collected_keys.erase(tag)
		remove_key_from_ui(tag)
		emit_signal("key_used", tag)
		print("Used key:", tag)
		return true
		
	return false

func _add_key_to_ui(tag: String, icon: Texture2D) -> void:
	var key_ui = KEY_UI_SCENE.instantiate()
	var icon_node: TextureRect = key_ui.get_node("Icon")
	var label_node: Label = key_ui.get_node("TagLabel")
	icon_node.texture = icon
	label_node.text = tag

	keys_container.add_child(key_ui)
	key_ui.modulate.a = 0
	key_ui.position = Vector2(60 * (collected_keys.size() - 1), 0)

	var tween = create_tween()
	tween.tween_property(key_ui, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	
func remove_key_from_ui(tag: String):
	for key_ui in keys_container.get_children():
		var label_node = key_ui.get_node("TagLabel")
		if label_node.text.to_lower() == tag.to_lower():
			key_ui.queue_free()
			break
	
