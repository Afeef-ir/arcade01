extends CanvasLayer  # or Control
signal cut_scene_finished
signal cut_scene_started
@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $Control/Cutscene/AnimationPlayer
@onready var cutscene: Node2D = $Control/Cutscene

var started := false
func _ready() -> void:
	cutscene.show()
	started = true
	label.hide()
	anim.play("CutScene")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Skip"):
		skip()
		
		



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	skip()
	


func _on_animation_player_animation_started(_anim_name: StringName) -> void:
	emit_signal("cut_scene_started")
	
func skip():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
	
