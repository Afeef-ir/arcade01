extends StaticBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var door_col: CollisionShape2D = $DoorCol
@export var tag_d: Label 

@export var player:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if animated_sprite_2d.animation == "Open":
		door_col.disabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Key"):
		body.remove_from_group("Key")
		
		
		
