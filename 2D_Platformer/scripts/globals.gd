extends Node

var coins := 0
var score := 0
var player_life := 3
 
var player = null
var player_start_position = null
var current_checkpoint = null

var temp_position = null

func respawn_player():
	player.temp_position = temp_position.global_position
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position

