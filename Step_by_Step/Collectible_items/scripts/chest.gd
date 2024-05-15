extends Area2D

@onready var anim = $anim
@onready var player = %player
@onready var alert = $alert

var open_chest := false

func _on_body_entered(body):
	if player.has_key:
		anim.play("open")
		player.has_key = false
		open_chest = true
	elif open_chest:
		alert.visible = false
	else:
		alert.visible = true

func _on_body_exited(body):
	alert.visible = false
