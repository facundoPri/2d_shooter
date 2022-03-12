extends KinematicBody2D

onready var target = get_node(target_path)

export var target_path = NodePath()

export var health = 100
export var max_speed = 200

var _velocity := Vector2.ZERO

func _physics_process(delta):
	if target == self:
		set_physics_process(false)
	var target_global_position = target.global_position
	_velocity = Steering.follow(_velocity,global_position,target_global_position,max_speed)
	_velocity = move_and_slide(_velocity)
	rotation = _velocity.angle()

func take_damage(amount):
	health -= amount
	$AnimationPlayer.play("damage")
	if health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group('projectiles'):
		take_damage(body.damage)
		body.queue_free()
