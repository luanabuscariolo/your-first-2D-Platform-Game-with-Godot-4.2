extends Area2D

@onready var anim = $anim

func _on_body_entered(body):
	if body.name == "player":
		anim.play("collected")
