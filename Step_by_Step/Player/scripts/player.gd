extends CharacterBody2D

const SPEED = 150.0
const AIR_FRICTION := 0.5

var player_life := 3
var is_jumping := false
var direction
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20

var jump_velocity
var gravity
var fall_gravity
var jump_velocity_knockback := -340

@export var jump_height := 64
@export var max_time_to_peak := 0.5

@onready var remote = $remote as RemoteTransform2D
@onready var anim = $anim

signal player_has_died()

func _ready():	
	player_life = 3
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.x = 0
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote.remote_path = camera_path

func _set_state():
	var state = "idle"
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "walk"
	if anim.name != state:
		anim.play(state)

func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	call_deferred("take_damage", knockback)

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if player_life > 0:
		player_life -= 1
		print("perdeu 1 vida")
		if knockback_force != Vector2.ZERO:
			knockback_vector = knockback_force
			var knockback_tween := get_tree().create_tween()
			if knockback_tween != null:
				knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
				anim.modulate = Color(1,0,0,1)
				knockback_tween.parallel().tween_property(anim, "modulate", Color(1,1,1,1), duration)
			else:
				print("Erro: falha ao criar tweener!")
		is_hurted = true
		await get_tree().create_timer(.3).timeout
		is_hurted = false
	else:
		call_deferred("queue_free")
		emit_signal("player_has_died")

