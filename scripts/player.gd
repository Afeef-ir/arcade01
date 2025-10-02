extends CharacterBody2D
signal health_depleted
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var p_layer_s_prite: AnimatedSprite2D = $PLayerSPrite
@onready var hurt_t_ime: Timer = $HurtTIme
@onready var slidecol: CollisionShape2D = $Slidecol

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
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wallslide: Timer = $wallslide
@onready var gunnlocation_1: Area2D = $gunnlocation1
@onready var thrust: AudioStreamPlayer2D = $Thrust
@onready var slide: AudioStreamPlayer2D = $Slide
@onready var gun: Node2D = $Gun
@onready var hutcol: CollisionShape2D = $HurtBox/Hutcol
@onready var playercol: CollisionShape2D = $Playercol
@onready var slidepos_1: Area2D = $slidepos1
@onready var slidepos_2: Area2D = $slidepos2
@onready var slide_time: Timer = $slideTime

var is_knocked_back: bool = false

var jumps_left:int = 0
@onready var gunoglocation: Area2D = $Gunoglocation
@onready var gunoglocation_2: Area2D = $Gunoglocation2

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
	if is_on_wall() and is_on_floor():
		pass
	elif p_layer_s_prite.animation == "thrust":
		pass
	elif is_on_floor_only():
		pass
	elif is_on_wall():
		pass
	else:
		pass
		#p_layer_s_prite.play("jump")
		
		#p_layer_s_prite.play("jump")
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
		slidecol.disabled = true
		jumps_left = MAX_JUMPS
	else: # gravity
		velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at	
	
	if is_on_wall():
		if is_on_floor():
				slidecol.disabled = true
		
		if is_on_wall_only():
			slide.play()
			p_layer_s_prite.play("slide")
			slide_time.stop()
		if is_on_floor():
			pass
		else:
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)   # get the collision info
				var normal = collision.get_normal()      # get the surface normal (Vector2)
	
	# check direction of wall
			
				if normal.x > 0:
					slidecol.disabled = false
					p_layer_s_prite.flip_h=true
					slidecol.position = slidepos_2.position
				elif normal.x < 0:
					slidecol.disabled = false
					p_layer_s_prite.flip_h=false
					slidecol.position = slidepos_1.position
				
			

		
		if Input.is_action_just_pressed("jump"):
			velocity = WALL_JUMP_VELOCITY * get_wall_normal()
			velocity.y += JUMP_VELOCITY
			no_input_timer = NO_INPUT_TIME
			slide_time.start()
			
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
				p_layer_s_prite.play("slide")
			if is_on_floor():
				if not footstep.playing:
					footstep.play()
					p_layer_s_prite.play("walk")
				
			if Input.is_action_pressed("fast") and is_on_floor():
				velocity.x *= SPRINT_SCALE
				footstep.pitch_scale= 1.5
			else:
				footstep.pitch_scale = 1
		else: # no horizontal input
			velocity.x = 0.0
			footstep.stop()
			
		if horizontal_input==0 and is_on_floor():
			p_layer_s_prite.play("default")
		if horizontal_input == -1:
			p_layer_s_prite.flip_h=true
			gunchange()
		else:
			p_layer_s_prite.flip_h=false
			gun.position = gunoglocation.position
		if Input.is_action_just_pressed("jump"):
			if jumps_left > 0 and jumps_left<2:
				var _particle = deathParticle.instantiate()
				_particle.position = gunnlocation_1.global_position
				_particle.rotation = global_rotation
				_particle.emitting = true
				_particle.amount = 50
				_particle.lifetime = 0.5
				_particle.explosiveness = 0
				_particle.modulate.a =12
				_particle.position.x -=5
				
				get_tree().current_scene.add_child(_particle)
				p_layer_s_prite.play("thrust")
				thrust.play()
				
				
				$Jump.play()
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				footstep.stop()
			if jumps_left>1:
				p_layer_s_prite.play("jump")
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
	# You can check if the area belongs to an enemy"res://sfx2/thrust.ogg"
	if area.name.contains("Enemy"):  
		health_player -= 40
		damage.play()
		hurt_t_ime.start()
		
		
		#velocity.y = JUMP_VELOCITY 
		#velocity.x = SPEED
		%ProgressBar.value = health_player
		
		animation_player.play("hurt")
		
		
		
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
	
func gunchange():
	if Input.is_action_pressed("move left"):
		gun.position = gunoglocation_2.position
		
	


func _on_slide_time_timeout() -> void:
	p_layer_s_prite.play("jump")
