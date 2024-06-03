extends Area2D

@onready var alert = %alert
@onready var key_pcam = $"../key/KeyPhantomCamera2D"
@onready var player = %player
@onready var extra_life = $extra_life
@onready var animation = $animation

var open_chest = false

func _process(delta):
	vida_extra()

func vida_extra():
	if Input.is_action_pressed("interact"): # tecla K
		if player.has_key:
			$anim.play("default")
			extra_life.visible = true
			animation.play("extra_life")
			Globals.player_life += 1
			player.has_key = false
			open_chest = true
			#await  get_tree().create_timer(2).timeout
			#extra_life.visible = false
		else:
			zoom_to_key()

func _on_body_entered(body):
	alert.visible = true

func _on_body_exited(body):
	alert.visible = false

func zoom_to_key():
	if !open_chest:
		key_pcam.set_priority(10)
		await  key_pcam.tween_completed
		await  get_tree().create_timer(0.5).timeout
		key_pcam.set_priority(0)
