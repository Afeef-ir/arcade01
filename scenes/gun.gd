extends Node2D

const bullet_scene = preload("res://scenes/bullet.tscn")

const AIM_SPEED = 6.5

const IS_PLAYER = true
@onready var  RotationOffset:Node2D = $RotationOffset
@onready var spriteShadow : Sprite2D = $RotationOffset/Sprite2D/shadow
@onready var ShootPos:Marker2D =%shoop_pos
@onready var exploding: AudioStreamPlayer2D = $exploding

var time_between_shot : float = 0.25
var can_shoot : bool = true

func _ready() -> void:
	$shoot_timer.wait_time = time_between_shot
	
func _physics_process(delta: float) -> void:
	var joy_axis_hor:float = Input.get_axis("aim right", "aim left")
	var joy_axis_vert:float = Input.get_axis("aim up", "aim down")
	var joy_aim:Vector2 = Vector2(-joy_axis_hor, joy_axis_vert)
	
	var aim_direction:Vector2 = joy_aim
	if joy_aim.is_zero_approx():
		var aim_point:Vector2 = get_global_mouse_position()
		aim_direction = aim_point - global_position
	
	RotationOffset.rotation = lerp_angle(RotationOffset.rotation, aim_direction.angle(), AIM_SPEED * delta)
	if Input.is_action_pressed("aim"):
		RotationOffset.rotation= get_angle_to(global_position) 
	spriteShadow.position = Vector2(-2,2).rotated(-RotationOffset.rotation)
	if Input.is_action_just_pressed("shoot")and can_shoot:
		_shoot()
		can_shoot=true
		$shoot_timer.start()
		
func _shoot():
	var new_bullet = bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = ShootPos.global_position
	new_bullet.global_rotation = ShootPos.global_rotation
	exploding.play()
	
	
	

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	
	
