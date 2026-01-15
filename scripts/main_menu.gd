extends Control

signal start_game

@onready var buttons_holder: VBoxContainer = $buttons_holder
@onready var aspect_ratio_container_2: AspectRatioContainer = $AspectRatioContainer2

@onready var aspect_ratio_container: AspectRatioContainer = $AspectRatioContainer





func _ready() -> void:
	buttons_holder.visible = true
	aspect_ratio_container_2.visible = false
	aspect_ratio_container.visible = true



func _on_button_pressed() -> void:
	emit_signal("start_game")

func _on_button_2_pressed() -> void:
	buttons_holder.visible = false
	aspect_ratio_container_2.visible = true
	aspect_ratio_container.visible = false


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	buttons_holder.visible = true
	aspect_ratio_container_2.visible = false
	aspect_ratio_container.visible = true
