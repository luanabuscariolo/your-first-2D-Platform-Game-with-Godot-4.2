extends Control
@onready var start = $start

func _ready():
	start.grab_focus()

#func _input(event):
	#start.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://levels/world_01.tscn")

func _on_credits_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
