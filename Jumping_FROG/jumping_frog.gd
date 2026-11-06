extends Microgame

@onready var player = get_node_or_null("SubViewportContainer/SubViewport/Frog")
@onready var balloon = $SubViewportContainer/SubViewport/BalloonPatterns
@onready var music = $Music

# Use for testing
#@onready var player = get_node_or_null("Frog")
#@onready var balloon = $BalloonPatterns

# camera
@export var cam_left := -500
@export var cam_top := -3000
@export var cam_right := 1000
@export var cam_bottom := 550

# set camera and called level() to initialize level
func _ready() -> void:
	super()
	player.set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	level()
	music.play()

# choose a level
func level() -> void:
	var patterns = balloon.get_children()
	if patterns.is_empty():
		return

	var choice = patterns.pick_random()
	for i in patterns:
		if i == choice:
			i.visible = true
		else:
			i.queue_free()

# Win game signal
func _on_end_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		win_game.emit()
