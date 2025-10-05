extends Area2D
@onready var key: Area2D = $Key
@onready var keysprite: Sprite2D = $Key/Keysprite
@onready var key_collison: CollisionShape2D = $Key/KeyCollison

@export var door : Node2D
@export var door_sprite : AnimatedSprite2D
@export var door_collison : CollisionShape2D

var has_key : bool = false

func _ready() -> void:
	door_sprite.animation = "Closed"
	
	if door_sprite.animation == "Open":
		door_collison.disabled=true
	if door_sprite.animation=="Closed":
		door_collison.disabled = false
		
func _on_key_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player"):
		keysprite.queue_free()
		key_collison.queue_free()
		has_key = true
		door_collison.queue_redraw()


func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("Player")and has_key==true:
		door_sprite.animation = "Open"
		door_collison.queue_free()
		has_key=false
		
