extends CharacterBody2D

@onready var anim = $anim

func _on_anim_animation_finished(anim_name: StringName):
	if anim_name == "death":
		queue_free()
