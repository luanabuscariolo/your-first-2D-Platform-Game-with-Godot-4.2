extends Area2D

@onready var anim = $"../anim2"

func _on_body_entered(body):
	if body.name == "player":
		print("player colidiu")
		body.velocity.y = body.jump_velocity_knockback
		anim.play("hurt")
