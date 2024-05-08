extends CharacterBody2D
class_name Pushables

const PUSH_SPEED = 300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	velocity.x = 0

func slide_object(direction):
	velocity.x = int(direction.x) * PUSH_SPEED
