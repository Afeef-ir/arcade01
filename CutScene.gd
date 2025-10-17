extends CanvasLayer  # or Control

@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $Control/Cutscene/AnimationPlayer
@onready var cutscene: Node2D = $Control/Cutscene

var started := false
func _ready() -> void:
	label.show()
	cutscene.hide()

func _enter_tree() -> void:
	if anim and anim.is_playing():
		anim.stop()  # prevent auto-play

func _input(event: InputEvent) -> void:
	if started: return
	if event.is_action_pressed("Skip"):  # Enter
		cutscene.show()
		started = true
		label.hide()
		anim.play("CutScene")
