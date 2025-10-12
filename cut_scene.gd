extends CanvasLayer

@onready var label = $Label

var lines = [
	"In the beginning, there was only silence...",
	"Then, a spark of light appeared.",
	"And everything changed forever."
]

var current_line = 0
var typing = false

func _ready():
	show_line(current_line)

func show_line(index):
	if index >= lines.size():
		print("Cutscene ended!")
		return
	label.text = ""
	typing = true
	type_text(lines[index])

func type_text(text):
	var i = 0
	while i < text.length() and typing:
		label.text += text[i]
		i += 1
		await get_tree().create_timer(0.03).timeout
	typing = false

func _input(event):
	if event.is_action_pressed("Skip"):  # Space or Enter
		if typing:
			label.text = lines[current_line]
			typing = false
		else:
			next_line()

func next_line():
	current_line += 1
	if current_line < lines.size():
		show_line(current_line)
	else:
		print("Cutscene finished!")
		label.hide()
