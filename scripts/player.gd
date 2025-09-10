extends CharacterBody2D

@onready var jump: AudioStreamPlayer2D = $"../Jump"


@onready var footstep: AudioStreamPlayer2D = $footstep

const SPEED:float = 115.0
const JUMP_VELOCITY:float = -270.0
const WALL_JUMP_VELOCITY:float = 150.0 
const WALL_FACTOR:float = 0.75
const GRAVITY_SCALE:float = 0.7
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.3

var jumps_left:int = 0

var no_input_timer:float = 0.0
func _ready() -> void:
	pass
		
		
func _physics_process(delta: float) -> void:
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
					
			if Input.is_action_pressed("fast"):
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
