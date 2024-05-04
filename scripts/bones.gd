extends CharacterBody2D

var move_speed := 50.0
var direction := 1
var time_start = 0
var time_now = 0
var dist = 0

func _ready():
	time_start = Time.get_unix_time_from_system()

func _process(delta):
	position.x += move_speed * direction * delta
	dist += abs(move_speed * direction * delta)
	time_now = Time.get_unix_time_from_system()
	var time_elapsed = time_now - time_start
	if dist > 250 or time_elapsed > 5:
		queue_free()

func set_direction(dir):
	direction = dir
	if dir < 0:
		$anim.flip_h = true
	else: 
		$anim.flip_h = false

