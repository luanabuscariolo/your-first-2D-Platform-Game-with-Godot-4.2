extends Node2D

@onready var player = $"%player" as CharacterBody2D
@onready var camera = $camera as Camera2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var player_start_position = $player_start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func reload_game():
	#await  get_tree().create_timer(1.0).timeout
	#get_tree().reload_current_scene()
	var player = player_scene.instantiate()
	add_child(player)
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	#Globals.coins = 0
	#Globals.score = 0
	#Globals.player_life = 3
	Globals.respawn_player()
