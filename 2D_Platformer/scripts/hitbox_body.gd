extends Area2D
@onready var collision = $collision
@onready var anim = $"../anim"
@onready var player_detector = $"../player_detector"

func _physics_process(delta):
	if player_detector.is_colliding():
		collision.disabled = false
	else:
		collision.disabled = true

func _on_body_entered(body):
	if body.name == "player":
		if body.attack:
			print("atacou")
			anim.play("hurt_2")
