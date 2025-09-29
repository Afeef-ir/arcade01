extends CharacterBody2D
signal health_depleted
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var p_layer_s_prite: AnimatedSprite2D = $PLayerSPrite
@onready var hurt_t_ime: Timer = $HurtTIme
@onready var gun: Node2D = $"."
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var damage: AudioStreamPlayer2D = $Damage
@onready var hurt_box: Area2D = $HurtBox
@onready var footstep: AudioStreamPlayer2D = $footstep
@onready var maxHealth = 30
@onready var currentHealth : int = maxHealth
const SPEED:float = 115.0
const JUMP_VELOCITY:float = -360.0
const WALL_JUMP_VELOCITY:float = 150.0 
const WALL_FACTOR:float = 0.75
var  GRAVITY_SCALE:float = 0.7
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.3
@onready var bg_music: AudioStreamPlayer2D = $"bg music"
@onready var player: CharacterBody2D = $"."
var is_paused = false
@export var  deathParticle : PackedScene
@onready var deathtimer: Timer = $deathtimer
@onready var camera_2d_2: Camera2D = $Camera2D2
@onready var deathaudio: AudioStreamPlayer2D = $Deathaudio
@export var knockback_force: float = 300
@export var knockback_time: float = 0.2
@export var knockback_upward: float = 200

var is_knocked_back: bool = false

var jumps_left:int = 0

var health_player = 100.0

var no_input_timer:float = 0.0
func _ready() -> void:
	hurt_box.area_entered.connect(_on_HurtBox_area_entered)
		
func _physics_process(delta: float) -> void:
	if is_knocked_back:
		# Move player during knockback
		move_and_slide()
		return
	floor_max_angle = deg_to_rad(45)
	floor_snap_length= 8
	#const DAMAGE_RATE = 40.0
	#var overlapping_mobs =hurt_box.has_overlapping_areas()
	#if overlapping_mobs:
	#
		#health_player-= 40.0 * delta
		#
		#
	#
		#$Jump.play()
		#velocity.y = JUMP_VELOCITY
		#if health_player<= 0.0:
			#get_tree().reload_current_scene()
	if is_paused:
		return
	if is_on_floor():
		jumps_left = MAX_JUMPS
	else: # gravity
		velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at	
	
	if is_on_wall_only():
		
		if Input.is_action_just_pressed("jump"):
			velocity = WALL_JUMP_VELOCITY * get_wall_normal()
			velocity.y += JUMP_VELOCITY
			no_input_timer = NO_INPUT_TIME
			
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
			if is_on_floor():
				if not footstep.playing:
					footstep.play()
				
			if Input.is_action_pressed("fast") and is_on_floor():
				velocity.x *= SPRINT_SCALE
				footstep.pitch_scale= 1.5
			else:
				footstep.pitch_scale = 1
		else: # no horizontal input
			velocity.x = 0.0
			footstep.stop()
		
		if Input.is_action_just_pressed("jump"):
			if jumps_left > 0:
				$Jump.play()
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				footstep.stop()
		
	move_and_slide()
func pause():
	is_paused = true
func resume():
	is_paused = false

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	player.PROCESS_MODE_DISABLED
func _on_HurtBox_area_entered(area: Area2D) -> void:
	# You can check if the area belongs to an enemy
	if area.name.contains("Enemy"):  
		health_player -= 40
		damage.play()
		hurt_t_ime.start()
		
		
		#velocity.y = JUMP_VELOCITY 
		#velocity.x = SPEED
		%ProgressBar.value = health_player
		p_layer_s_prite.play("hurt")
	
		
		
		
	if health_player <= 0:
		p_layer_s_prite.hide()
		gun.hide()
		velocity.y=0
		velocity.x=0
		GRAVITY_SCALE=0
		var _particle = deathParticle.instantiate()
		_particle.position = global_position
		_particle.rotation = global_rotation
		_particle.emitting = true
		_particle.amount = 100
		get_tree().current_scene.add_child(_particle)
		deathaudio.play()
		deathtimer.start()
		set_process(false)
		set_physics_process(false)

func _on_hurt_t_ime_timeout() -> void:
	p_layer_s_prite.play("default")


func _on_deathtimer_timeout() -> void:
	get_tree().reload_current_scene()
func apply_knockback(from_position: Vector2) -> void:
	# Calculate direction away from enemy
	var direction = (global_position - from_position).normalized()
	velocity = Vector2(direction.x * knockback_force, -knockback_upward)
	
	is_knocked_back = true
	
	# Timer to end knockback
	var t = get_tree().create_timer(knockback_time)
	await t.timeout
	is_knocked_back = false
