extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible_ratio<1:
		visible_ratio += 0.1 *delta * 2.5
