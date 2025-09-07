extends CharacterBody2D

const SPEED:float = 400.0
const JUMP_VELOCITY:float = -950.0
const WALL_JUMP_VELOCITY:float = 500.0 
const WALL_FACTOR:float = 0.75
const GRAVITY_SCALE:float = 2.5
const MAX_JUMPS:int = 2
const SPRINT_SCALE:float = 2.0
const NO_INPUT_TIME = 0.33

var jumps_left:int = 0

var no_input_timer:float = 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps_left = MAX_JUMPS
	else: # gravity
		velocity += get_gravity() * delta * GRAVITY_SCALE # v = u + at	
	
	if is_on_wall():
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
		if horizontal_input:
			velocity.x = horizontal_input * SPEED # -SPEED to SPEED
			if Input.is_action_pressed("fast"):
				velocity.x *= SPRINT_SCALE
		else: # no horizontal input
			velocity.x = 0.0
		
		if Input.is_action_just_pressed("jump"):
			if jumps_left > 0:
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1
				
		
	move_and_slide()
