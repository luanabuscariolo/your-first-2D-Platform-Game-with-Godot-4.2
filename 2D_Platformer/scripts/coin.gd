extends Area2D

var coins := 1

@onready var anim = $anim
@onready var animation = $animation

func _on_body_entered(body):
	if body.name == "player":
		animation.play("collect_position")
		#anim.play("collected")
		await $collision.call_deferred("queue_free")
		Globals.coins += coins
		print(Globals.coins)

func _on_anim_animation_finished():
	#queue_free()
	pass
