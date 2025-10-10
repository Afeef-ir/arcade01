extends StaticBody2D


@onready var sliding_door: Sprite2D = $SlidingDoor
@onready var lock: AnimatedSprite2D = $Lock
@onready var lock_pos_left: Marker2D = $lock_pos_left	
@onready var door_collison_pos: Marker2D = $DoorCollison_pos
@onready var lock_area_pos: Marker2D = $LockAreaPos
@onready var lock_area: Area2D = $LockArea
@onready var lock_col: CollisionShape2D = $LockCol

@export var is_left : bool
@export var required_key_tag: String = "red"
@export var consume_key: bool = true
var player_in_range = null

func _ready():
	if is_left:
		lock.global_position = lock_pos_left.global_position
		lock.flip_h = true
		lock_col.global_position = door_collison_pos.global_position
		lock_area.global_position = lock_area_pos.global_position
	lock_area.connect("body_entered", Callable(self, "_on_lock_area_body_entered"))
	lock_area.connect("body_exited", Callable(self, "_on_lock_area_body_exited"))


		
func attempt_open(player) -> void:
	player_in_range = player
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
	print("Door opened with key:", required_key_tag)
	if has_node("AnimationPlayer"):
		pass
	lock_area.monitoring = false
	lock_col.disabled = true
	lock_col.queue_free()
	lock_area.queue_free()
	sliding_door.hide()
	sliding_door.queue_free()
func _deny_open():
	print("Door locked! needs key:", required_key_tag)

		
		
		


func _on_lock_area_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player_in_range = body
		attempt_open(player_in_range)
