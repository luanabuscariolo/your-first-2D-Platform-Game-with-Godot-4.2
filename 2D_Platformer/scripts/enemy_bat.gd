extends CharacterBody2D

var state = "fly"

@onready var anim = $anim

func _ready():
	anim.animation_finished.connect(animHasFinished)
	
func animHasFinished():
	if state == "damaged":
		queue_free()

