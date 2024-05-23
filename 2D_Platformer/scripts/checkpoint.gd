extends Area2D

var is_active = false
@onready var anim = $anim
@onready var marker_2d = $Marker2D

func _on_body_entered(body):
	if body.name != "player" or is_active:
		return
	active_checkpoint()

func active_checkpoint():
	Globals.current_checkpoint = marker_2d
	anim.play("checked")
	is_active = true



