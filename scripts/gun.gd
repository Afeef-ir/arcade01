extends Node2D

const bullet_scene = preload("res://scenes/bullet.tscn")
const AIM_SPEED = 6.5
const IS_PLAYER = true

@onready var  RotationOffset:Node2D = $RotationOffset
@onready var ShootPos:Marker2D = $RotationOffset/Sprite2D/ShootPos
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSfx


var time_between_shot : float = 0.25
var can_shoot : bool = true
var last_mouse_pos : Vector2 = Vector2.ZERO
var aim_direction : Vector2 = Vector2.ZERO
var shoot_method : String = "shoot"
var mouse_pos_

func _ready() -> void:
	#print(get_parent().get_node("player_hud/TouchButtons/Jump"))
	$shoot_timer.wait_time = time_between_shot
	shoot_sfx.bus = "Music"
	mouse_pos_ = RotationOffset.global_position -  get_global_mouse_position()
	
func _physics_process(delta: float) -> void:
	var jump_btn = get_parent().get_node("player_hud/Control/TouchButtons/Jump")
	var sprint_btn = get_parent().get_node("player_hud/Control/TouchButtons/Sprint")
	var joystick = get_parent().get_node("player_hud/Control/TouchButtons/VirtualJoystick")
	var Menu = get_parent().get_node("player_hud/Control/Menu")
	var joy_axis_hor:float = Input.get_axis("aim right", "aim left")
	var joy_axis_vert:float = Input.get_axis("aim up", "aim down")
	var joy_aim:Vector2 = Vector2(-joy_axis_hor, joy_axis_vert)
	var diff = RotationOffset.global_position -  get_global_mouse_position()
	var mouse_pos:Vector2 = DisplayServer.mouse_get_position()

	if joy_aim.is_zero_approx():
		if not mouse_pos.is_zero_approx():
			if mouse_pos_ != null:
				if mouse_pos_ + Vector2(15,15) > diff and mouse_pos_ - Vector2(15,15) < diff:
					pass
				else:
					aim_direction = get_global_mouse_position() - global_position
	else:
		aim_direction = joy_aim
		mouse_pos_ = RotationOffset.global_position -  get_global_mouse_position()
	last_mouse_pos = mouse_pos
	
	RotationOffset.rotation = lerp_angle(RotationOffset.rotation, aim_direction.angle(), AIM_SPEED * delta * 5)
	if jump_btn.is_pressed():
		can_shoot = false
		await jump_btn.released
		can_shoot = true
	if sprint_btn.is_pressed():
		can_shoot = false
		await sprint_btn.released
		can_shoot = true
	if Menu.is_pressed():
		can_shoot = false
		await Menu.released
		can_shoot = true
	#if joystick.is_pressed():
		#can_shoot = false
		#await jump_btn.released
		#can_shoot = true
	if Input.is_action_just_pressed(shoot_method) and can_shoot:
		_shoot()
		can_shoot=true
		$shoot_timer.start()
		
func _shoot():
	if not can_shoot:
		return
	var new_bullet = bullet_scene.instantiate()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_position = ShootPos.global_position
	new_bullet.global_rotation = ShootPos.global_rotation
	shoot_sfx.play()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
