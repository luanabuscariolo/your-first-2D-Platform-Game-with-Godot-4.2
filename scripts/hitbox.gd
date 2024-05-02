extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		body.velocity.y = body.JUMP_VELOCITY
		get_parent().state = "damaged"
		owner.anim.play("damaged")
