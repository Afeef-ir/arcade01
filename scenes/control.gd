extends Control

signal pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_on_menu_pressed()


func _on_menu_pressed() -> void:
	print(2)
	emit_signal("pressed")
	
