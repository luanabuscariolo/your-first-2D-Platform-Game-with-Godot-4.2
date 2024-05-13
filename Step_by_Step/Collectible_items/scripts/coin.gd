extends Area2D

@onready var anim = $anim

func _on_body_entered(body):
	if body.name == "player":
		anim.play("collected")

func _on_anim_animation_finished():
	queue_free()
