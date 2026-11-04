extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -650.0
@export var dash_velocity: float = 1000.0
@export var fall_distance: float = 80.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_x: float = -1.0
var is_dashing: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

# move and animation
func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_dashing = false # cannot dash on floor
	
	# Move
	var direction = Input.get_axis("keyboard_left", "keyboard_right")
	if direction != 0:
		velocity.x = direction * speed
		direction_x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Jump
	if Input.is_action_just_pressed("keyboard_action") and is_on_floor():
		velocity.y = jump_velocity
	
	# Dash
	if Input.is_action_just_pressed("mouse_left") and not is_on_floor():
		velocity.y = dash_velocity
		is_dashing = true

	move_and_slide()
	update_animations()

# Animation Control
func update_animations() -> void:
	animation_tree.set("parameters/Idle/blend_position", direction_x)
	animation_tree.set("parameters/Run/blend_position", direction_x)
	animation_tree.set("parameters/Up/blend_position", direction_x)
	animation_tree.set("parameters/Flip/blend_position", direction_x)
	animation_tree.set("parameters/Fall/blend_position", direction_x)
	animation_tree.set("parameters/Dash/blend_position", direction_x)

	if is_on_floor():
		if abs(velocity.x) > 10:
			playback.travel("Run")
		else:
			playback.travel("Idle")
	else:
		var near_floor = test_move(global_transform, Vector2(0, fall_distance))
		if near_floor:
			is_dashing = false
			playback.travel("Fall")
		elif is_dashing:
			playback.travel("Dash")
		elif velocity.y < 0:
			playback.travel("Up")
		else:
			playback.travel("Flip")

# Camera setting
func set_camera_limits(left: int, top: int, right: int, bottom: int):
	$Camera2D.limit_left = left
	$Camera2D.limit_top = top
	$Camera2D.limit_right = right
	$Camera2D.limit_bottom = bottom
