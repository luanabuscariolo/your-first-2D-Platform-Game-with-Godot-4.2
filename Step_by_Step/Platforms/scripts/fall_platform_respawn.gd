extends RigidBody2D

@onready var respawn_position = self.global_position
@onready var anim = $anim

func _on_body_detector_body_entered(body):
	if body.name == "player":
		anim.play("alert")
		await get_tree().create_timer(1).timeout
		set_deferred("freeze", false)
		$respawn_timer.start()

func respawn_platform():
	global_position = respawn_position
	anim.play("RESET")
	set_deferred("freeze", true)

func _on_respawn_timer_timeout():
	respawn_platform()
	
