extends CharacterBody2D

const SPEED = 150.0
const AIR_FRICTION := 0.5

var is_jumping := false
var direction
var is_hurted := false
var rolling := false
var roll_start := false
var finished_level := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20

var jump_velocity
var gravity
var fall_gravity
var jump_velocity_knockback := -340
var attack = false

var has_key := false

@export var jump_height := 64
@export var max_time_to_peak := 0.5

@export var move_distance := 200.0 # A distância que o jogador deve percorrer após terminar a fase
var distance_moved := 0.0 # Distância percorrida até agora

@onready var remote = $remote as RemoteTransform2D
@onready var anim = $anim

@onready var chest = %chest
@onready var chest_pcam = $"../../chest/ChestPhantomCamera2D"
@onready var key = %key
@onready var key_pcam = $"../../key/KeyPhantomCamera2D"

signal player_has_died()

func _ready():
	key.body_entered.connect(zoom_to_chest)
	key.body_exited.connect(return_to_player_cam)
	chest.body_exited.connect(return_to_player_cam)
	
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if !finished_level:
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
	else:
		if distance_moved < move_distance:
			var move_step = SPEED * delta
			velocity.x = SPEED
			distance_moved += move_step
		else:
			velocity.x = 0
	
	_set_state()
	move_and_slide()
	drop_platform()
	apply_push_force()
	attacking()



func follow_camera(camera):
	var camera_path = camera.get_path()
	remote.remote_path = camera_path

func _set_state():
	var state = "idle"
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "walk"
	
	if is_hurted:
		state = "hurt"
		
	if roll_start:
		state = "roll_start"
	
	if rolling:
		state = "rolling"
	
	if attack:
		state = "attack"
	
	if anim.name != state:
		anim.play(state)

func attacking():
	if Input.is_action_pressed("attack"):
			attack = true
			await anim.animation_finished
			attack = false

func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	call_deferred("take_damage", knockback)
	
	if body.is_in_group("bones"):
		body.queue_free()

func drop_platform():
	if Input.is_action_pressed("drop_platform"):
		position.y += 1

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
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
		#para evitar manipulações de cena durante a sinalização:
		#call_deferred("queue_free")
		emit_signal("player_has_died")

func apply_push_force():
	for objects in get_slide_collision_count():
		var collision = get_slide_collision(objects)
		if collision.get_collider() is Pushables:
			collision.get_collider().slide_object(-collision.get_normal())

func next_level():
	finished_level = true
	distance_moved = 0.0 # Resetar a distância percorrida
	#roll_start = true
	#await  anim.animation_finished
	rolling = true

func zoom_to_chest(body):
	set_physics_process(false)
	chest_pcam.set_priority(10)
	await  chest_pcam.tween_completed
	await  get_tree().create_timer(0.5).timeout
	chest_pcam.set_priority(0)
	set_physics_process(true)
	has_key = true
	key.body_entered.disconnect(zoom_to_chest)
	key.queue_free()

func return_to_player_cam(body):
	if key_pcam != null:
		key_pcam.set_priority(0)
	chest_pcam.set_priority(0)


