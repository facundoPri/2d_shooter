extends KinematicBody2D

export var speed := 500
export var friction = 0.18

var _velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

func _physics_process(_delta):
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	# Using the follow steering behavior.
	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)

	if direction == Vector2.ZERO:
		animated_sprite.animation = 'idle'
	else:
		animated_sprite.animation = 'run'


# The code below updates the character's sprite to look in a specific direction.
func _unhandled_input(event):
	if event.is_action_pressed("right"):
		animated_sprite.flip_h = false
	elif event.is_action_pressed("left"):
		animated_sprite.flip_h = true
