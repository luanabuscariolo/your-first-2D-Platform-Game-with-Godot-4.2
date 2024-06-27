extends CharacterBody2D

const speed = 15
var dir: Vector2
#var direction := 1
var is_bat_chase: bool
var player: CharacterBody2D

#@onready var wall_detector = $wall_detector
@onready var texture = $texture
#@onready var anim = $anim2

@export var enemy_score := 100

func _ready():
	is_bat_chase = false

func _process(delta):
	move(delta)
	#handle_animation()
	flip_direction()

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
		#print(dir)

func choose(array):
	array.shuffle()
	return array.front()

#func handle_animation():
	#anim.play("fly")
	#if dir.x == -1:
		#anim.flip_h = true
	#elif dir.x == 1:
		#anim.flip_h = false

func flip_direction():
	#if wall_detector.is_colliding():
		#direction *= -1
		#wall_detector.scale.x *= -1
	if dir.x == -1:
		texture.flip_h = true
	else:
		texture.flip_h = false

#func _on_anim_animation_finished():
	#print("entrou fim animação")
	#if anim == "hurt":
		#print("anim == hurt")
		#Globals.score += enemy_score
		#queue_free()

func _on_anim_2_animation_finished(anim_name):
	print("entrou fim animação")
	if anim_name == "hurt":
		print("anim == hurt")
		Globals.score += enemy_score
		queue_free()
