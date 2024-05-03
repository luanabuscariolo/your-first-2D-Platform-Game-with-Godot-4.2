extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction

@onready var remote = $remote as RemoteTransform2D
@onready var anim = $anim

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_set_state()
	move_and_slide()
	drop_platform()

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
	if body.is_in_group("enemies"):
		queue_free()

func drop_platform():
	if Input.is_action_pressed("drop_platform"):
		position.y += 1





