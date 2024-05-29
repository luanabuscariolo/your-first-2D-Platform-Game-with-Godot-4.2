extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		body.velocity.y = body.jump_velocity_knockback
		#get_parent().anim.play("hurt")
