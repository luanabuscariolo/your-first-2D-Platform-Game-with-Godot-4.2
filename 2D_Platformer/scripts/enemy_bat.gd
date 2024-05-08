extends CharacterBody2D
var state = "fly"
func animHasFinished():
	if state == "damaged":
		queue_free()
@onready var anim = $anim
func _ready():
	anim.animation_finished.connect(animHasFinished)
