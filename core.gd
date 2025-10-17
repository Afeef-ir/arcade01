extends Node2D

func _ready() -> void:
	var cutscene = load("res://scenes/Cutscene.tscn").instantiate()
	add_child(cutscene)
	
	# wait a frame so children exist
	await get_tree().process_frame
	
	# try exact path first, fallback to recursive search
	var anim = cutscene.get_node_or_null("Control/Node2D/Cutscene/AnimationPlayer")
	if anim == null:
		anim = _find_anim_player(cutscene)
	
	if anim == null:
		printerr("AnimationPlayer not found!")
		return
	
	anim.connect("animation_finished", Callable(self, "_on_cutscene_finished"))

# recursive fallback to find AnimationPlayer
func _find_anim_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var f := _find_anim_player(child)
		if f:
			return f
	return null

func _on_cutscene_finished(anim_name: StringName) -> void:
	print("Cutscene finished")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
