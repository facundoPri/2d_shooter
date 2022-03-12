extends KinematicBody2D

signal die

export var speed = 400
export var friction = 0.18
export var projectile_speed = 500
export var fire_rate = 0.3
export var recoil_range_deg = 20
export var projectiles_per_fire = 10

var _velocity := Vector2.ZERO
var shotgun_mode = true

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var gun:= $Gun

var projectile = preload("res://Projectile.tscn")
var can_fire = true

func _process(_delta):
	gun.look_at(get_global_mouse_position())
	if Input.is_action_pressed("fire") and can_fire:
		for _i in range(projectiles_per_fire):
			fire()

func fire():
	$AnimationPlayer.play("shoot")
	var projectile_instance = projectile.instance()
	projectile_instance.position = $Gun/ProjectilePoint.get_global_position()
	var random_recoil_deg = rand_range(-recoil_range_deg, recoil_range_deg)
	var random_recoil_rad = deg2rad(random_recoil_deg)
	projectile_instance.rotation_degrees = gun.rotation_degrees + random_recoil_deg
	var projectile_impulse = Vector2(projectile_speed, 0).rotated(gun.rotation + random_recoil_rad)
	projectile_instance.apply_impulse(Vector2(), projectile_impulse)
	get_tree().get_root().add_child(projectile_instance)
	can_fire = false
	yield(get_tree().create_timer(fire_rate),'timeout')
	can_fire = true

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
	if event.is_action_released("change_gun"):
		print('test')
		shotgun_mode = not shotgun_mode
		if shotgun_mode:
			fire_rate = 0.3
			projectiles_per_fire = 10
			recoil_range_deg = 20
			projectile_speed = 500
		else:
			fire_rate = 0
			projectiles_per_fire = 1
			recoil_range_deg = 3
			projectile_speed = 400


func _on_Area2D_body_entered(body):
	emit_signal("die")
	queue_free()
