extends RigidBody2D

@onready var respawn_position = self.global_position

func _on_body_detector_body_entered(body):
	if body.name == "player":
		set_deferred("freeze", false)
		$respawn_timer.start()

func respawn_platform():
	global_position = respawn_position
	set_deferred("freeze", true)

func _on_respawn_timer_timeout():
	respawn_platform()
