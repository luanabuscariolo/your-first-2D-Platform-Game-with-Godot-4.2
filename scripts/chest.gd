extends Area2D

@onready var alert = %alert
@onready var key_pcam = $"../key/KeyPhantomCamera2D"
@onready var player = %player

func _process(delta):
	if Input.is_action_pressed("interact"):
		if player.has_key:
			$anim.play("default")
		else:
			zoom_to_key()

func _on_body_entered(body):
	alert.visible = true

func _on_body_exited(body):
	alert.visible = false

func zoom_to_key():
	key_pcam.set_priority(10)
	await  key_pcam.tween_completed
	await  get_tree().create_timer(0.5).timeout
	key_pcam.set_priority(0)
