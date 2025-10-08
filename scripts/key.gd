extends Area2D

@onready var key: Area2D = $"."
@onready var keysprite: Sprite2D = $Keysprite
@onready var label: Label = $CanvasLayer/Label

@export var player:CharacterBody2D
var door = preload("res://scenes/door.tscn")
@export var tag : Label

func _ready() -> void:
	label.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var Canvas_layer = get_node("CanvasLayer")
		Canvas_layer.add_child(keysprite)
		var door_scene = door.instantiate()
		var door_label = door_scene.get_node("RichTextLabel")
		var door_col = door_scene.get_node("DoorCol")
		door_col.queue_free()
		if door_label == tag:
			print("jid a")
		keysprite.global_position = label.global_position
		label.visible = true
