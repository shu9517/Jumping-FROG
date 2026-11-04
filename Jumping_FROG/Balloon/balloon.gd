extends Area2D

@export var speed: float = 4
@export var amplitude: float = 15.0
@export var bounce: float = -850.0
@export var dash: float = -1000.0

@onready var sprite: Sprite2D = $Sprite2D

var color: int = 0
var start_y: float = 0.0
var time: float = 0.0
var squished: bool = false

func _ready() -> void:
	start_y = position.y
	time = randf() * 10.0
	color = randi_range(0, 4)
	sprite.frame = color * 2

func _physics_process(delta: float) -> void:
	time += speed * delta
	position.y = start_y + sin(time) * amplitude #up down movement

	for body in get_overlapping_bodies():
		if body.name == "Frog" and body.velocity.y >= 0:
			bounce_up(body)

# when frog on it
func bounce_up(frog: CharacterBody2D) -> void:
	if frog.is_dashing:
		frog.velocity.y = dash
		frog.is_dashing = false
	else:
		frog.velocity.y = bounce

	if not squished:
		squished = true
		sprite.frame = color * 2 + 1
		await get_tree().create_timer(1).timeout
		sprite.frame = color * 2
		squished = false
