extends RigidBody2D

func _on_coin_tree_exited():
	queue_free()
