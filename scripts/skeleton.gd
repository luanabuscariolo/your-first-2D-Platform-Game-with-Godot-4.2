extends CharacterBody2D

const BONE = preload("res://prefabs/bones.tscn")
var move_speed := 30
var direction := 1
var health_points := 3

@onready var sprite = $sprite
@onready var anim = $anim
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector
@onready var bone_spawn_point = $bone_spawn_point
@onready var hurt_sprite = $sprite/hurt_sprite

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target := CharacterBody2D

func _physics_process(delta):
	match (current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()

func patrol_state():
	anim.play("limping")
	if is_on_wall():
		flip_enemy()
	if not ground_detector.is_colliding():
		flip_enemy()
	velocity.x = move_speed * direction
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	move_and_slide()

func attack_state():
	anim.play("attack")
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await get_tree().create_timer(0.3).timeout
	hurt_sprite.visible = false
	if health_points > 1:
		health_points -= 1
		print("Inimigo tomou dano")
		_change_state(EnemyState.PATROL)
	else:
		dead_state()
		await get_tree().create_timer(5).timeout
		revive_state()

func dead_state():
	anim.play("dead")
	$collision.disabled = true
	$hitbox/collision.disabled = true
	await  anim.animation_finished

func revive_state():
	anim.play("revive")
	$collision.disabled = false
	$hitbox/collision.disabled = false
	health_points = 3
	await  anim.animation_finished
	_change_state(EnemyState.PATROL)

func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	bone_spawn_point.position.x *= -1

func spawn_bone():
	var new_bone = BONE.instantiate()
	if sign(bone_spawn_point.position.x) == 1:
		new_bone.set_direction(1)
	else:
		new_bone.set_direction(- 1)
	add_sibling(new_bone)
	new_bone.global_position = bone_spawn_point.global_position

func _on_hitbox_body_entered(body):
	if current_state != EnemyState.HURT:
		_change_state(EnemyState.HURT)
		hurt_state()



