extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control2/Control/AnimationPlayer

signal cutscene_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("new_animation")
	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("cutscene_finished")
	queue_free()
