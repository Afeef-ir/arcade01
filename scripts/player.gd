extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -950.0

var jumps_left:int = 0

const total_jumps :int= 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2.5

	# Handle jump.
	
	if is_on_floor():
		jumps_left=total_jumps
		
	if Input.is_action_just_pressed("jump"):
		if jumps_left>0:
			velocity.y = JUMP_VELOCITY
			jumps_left -=1 
		
		 
	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move left" , "move right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction and Input.is_action_pressed("fast"):
		velocity.x= direction * SPEED * 2.0
	move_and_slide()
