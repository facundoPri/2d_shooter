extends Node

export (PackedScene) var mob_scene

func _process(delta):
	var amount_projectiles = get_tree().get_nodes_in_group('projectiles').size()
	$Label.text = 'Amount: '+str(amount_projectiles)


func _on_MobTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randi()
	
	var mob = mob_scene.instance()
	mob.target_path = NodePath('../Player')
	$YSort.add_child(mob)
	
	mob.position = mob_spawn_location.position
	


func _on_Player_die():
	get_tree().reload_current_scene()
