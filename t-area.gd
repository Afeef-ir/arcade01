extends Area2D

signal entered(from,to)
@export var from : int
@export var to : int


func _ready() -> void:
	body_entered.connect(Callable(self,"_on_body_entered"))
func _on_body_entered(body: CharacterBody2D) -> void:
	print("somene")
	if body.is_in_group("player"):
		print("yay")
		entered.emit(from,to)
		
