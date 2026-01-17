extends Node2D

@onready var bubble = $"Speech Bubble"
@onready var tail = $SpeechBubbleTail
@onready var label = $"Speech Bubble/Label"

# Dialogue
var dialogues = [
	"Hi there! So sorry to interrupt, but it's a bit of an emergency!",
	"I've heard that you're the best makeup artist in Ottawa. I need your help!",
	"I'm performing in a few hours, yet my team still hasn't arrived yet.",
	"I'm an easy client, I promise! I only have a few requests..."
]
var current_index = 0
var is_showing = false

# Fade transitions
func fade_in_node(node, duration = 0.3):
	node.visible = true
	node.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

func fade_out_node(node, duration = 0.3):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	var callback := func(): node.visible = false
	tween.finished.connect(callback)

func show_dialogue(index):
	label.text = dialogues[index]
	for node in [bubble, tail, label]:
		fade_in_node(node)

func hide_dialogue():
	for node in [bubble, tail, label]:
		fade_out_node(node)

# Click to advance dialogue
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		hide_dialogue()
		current_index += 1
		if current_index >= dialogues.size():
			current_index = 0
		# Delay to await fade-out
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.4
		add_child(timer)
		var callback := func():
			show_dialogue(current_index)
			timer.queue_free()
		timer.timeout.connect(callback)
		timer.start()

func _ready():
	# Hide everything initially
	for node in [bubble, tail, label]:
		node.visible = false
	# Show dialogue
	show_dialogue(current_index)
