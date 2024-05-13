extends Area2D

var collected_key := false

@onready var anim = $anim

func _on_body_entered(body):
	if body.name == "player":
		anim.play("collected")
		collected_key = true
