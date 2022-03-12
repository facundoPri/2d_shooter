extends Node

const DEFAULT_MASS = 2.0
const DEFAULT_MAX_SPEED = 400.0

static func follow(
	velocity,
	global_position,
	target_position,
	max_speed = DEFAULT_MAX_SPEED,
	mass = DEFAULT_MASS
):
	var desired_velocity = (target_position - global_position).normalized() * max_speed
	var steering = (desired_velocity - velocity) / mass
	var new_velocity = velocity + steering
	return new_velocity
