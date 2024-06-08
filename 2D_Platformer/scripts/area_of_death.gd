extends Area2D

func _on_body_entered(body):
	if body.name == "player" && body.has_method("deadth_to_life"):
		print("player morreu")
		body.deadth_to_life()
		#body.anim.play("tree")
