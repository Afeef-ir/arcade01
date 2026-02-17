extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		position.y-= 5
	if Input.is_action_pressed("ui_down"):
		position.y+= 5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * 2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*2)

	move_and_slide()
