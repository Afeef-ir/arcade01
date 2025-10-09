extends StaticBody2D

@onready var door_col: CollisionShape2D = $DoorCol

@export var required_key_tag: String = "red"
@export var consume_key: bool = true# optional if using AnimatedSprite/AnimationPlayer

var player_in_range = null

func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = body


func _on_body_exited(body):
	if body == player_in_range:
		player_in_range = null
		# hide UI hint

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("Pickup"):
		attempt_open(player_in_range)
func attempt_open(player) -> void:
	if not player or not player.has_method("has_key"):
		return
	if player.has_key(required_key_tag):
		# open the door
		_open()
		if consume_key:
			player.use_key(required_key_tag)
	else:
		_deny_open()

func _open():
	# Play animation, disable collision, etc.
	print("Door opened with key:", required_key_tag)
	# if using AnimationPlayer:
	if has_node("AnimationPlayer"):
		pass
	# disable area so it can't be reused
	$Area2D.monitoring = false
	# optionally remove or change sprite/collision
	if door_col.disabled == false:
		door_col.disabled = true

func _deny_open():
	# feedback: play sound or show "locked" message
	print("Door locked! needs key:", required_key_tag)
	# optionally play a locked sound or flash UI

		
		
		
