extends RigidBody2D

export var damage = 10


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
