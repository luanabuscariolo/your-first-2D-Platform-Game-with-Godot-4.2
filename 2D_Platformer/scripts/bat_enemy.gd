extends CharacterBody2D

const speed = 20
var dir: Vector2
var is_bat_chase: bool
var player: CharacterBody2D

func _ready():
	is_bat_chase = false

func _process(delta):
	move(delta)
	handle_animation()

func move(delta):
	if is_bat_chase:
		player = Globals.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x) / velocity.x
	elif !is_bat_chase:
		velocity += dir * speed * delta
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		print(dir)

func choose(array):
	array.shuffle()
	return array.front()

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("fly")
	if dir.x == -1:
		animated_sprite.flip_h = true
	elif dir.x == 1:
		animated_sprite.flip_h = false












