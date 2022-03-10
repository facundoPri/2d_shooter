extends RigidBody2D

func _on_Projectile_body_entered(body):
	print('ouch')
	if !body.is_in_group('player'):
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
