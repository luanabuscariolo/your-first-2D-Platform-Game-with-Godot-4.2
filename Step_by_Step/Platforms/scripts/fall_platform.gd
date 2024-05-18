extends RigidBody2D

@onready var respawn_position = self.global_position
@onready var anim = $anim
@onready var collision = $collision
@onready var collision_detector = $body_detector/collision_detector

func _on_body_detector_body_entered(body):
	if body.name == "player":
		anim.play("alert")
		await get_tree().create_timer(1).timeout
		collision.disabled = true
		collision_detector.disabled = true
		anim.play("falling")
		await get_tree().create_timer(3).timeout
		collision.disabled = false
		collision_detector.disabled = false

