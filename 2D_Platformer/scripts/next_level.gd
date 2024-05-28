extends Area2D

func _on_body_entered(body):
	Globals.player.next_level()
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://levels/world_02.tscn")
