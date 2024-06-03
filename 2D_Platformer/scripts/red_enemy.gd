extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var direction := -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumpToDie = false
var canContinueJumpingYAxis = true
@onready var anim := $anim
@onready var texture = $texture
@onready var wall_detector = $wall_detector

@export var enemy_score := 100

func _physics_process(delta):
	_apply_gravity(delta)
	movement(delta)
	flip_direction()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	if !jumpToDie:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x += direction * SPEED * 1.4 * delta
		if canContinueJumpingYAxis:
			velocity.y += -1.8 * gravity * delta
	move_and_slide()

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false

func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		Globals.score += enemy_score
		#queue_free()
		var playerX = Globals.player.position.x
		var thisEnemyX = position.x
		if playerX > thisEnemyX:
			direction = -1
		else:
			direction = 1
		jumpToDie = 1
		await get_tree().create_timer(.2).timeout
		canContinueJumpingYAxis = false
		gravity *= 1.5
		await get_tree().create_timer(.3).timeout
		queue_free()
		









