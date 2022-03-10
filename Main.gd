extends Node

func _process(delta):
	var amount_projectiles = get_tree().get_nodes_in_group('projectiles').size()
	$Label.text = 'Amount: '+str(amount_projectiles)
