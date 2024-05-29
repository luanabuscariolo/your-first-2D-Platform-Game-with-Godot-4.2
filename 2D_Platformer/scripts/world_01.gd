extends Node2D

@onready var player = $"%player" as CharacterBody2D
@onready var camera = $camera as Camera2D
@onready var player_scene = preload("res://actors/player.tscn")

func _ready():
	Globals.player_start_position = $player_start_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func reload_game():
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	Globals.respawn_player()
