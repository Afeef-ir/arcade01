extends CanvasLayer  # or Control
signal cut_scene_finished
@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $Control/Cutscene/AnimationPlayer
@onready var cutscene: Node2D = $Control/Cutscene

var started := false
func _ready() -> void:
	pass
	#cutscene.show()
	#started = true
	#label.hide()
	#anim.play("CutScene")
	

		
		



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	skip()
	

	
func skip():
	emit_signal("cut_scene_finished")
	


func _on_button_pressed() -> void:
	anim.stop()
	hide()
	skip()
