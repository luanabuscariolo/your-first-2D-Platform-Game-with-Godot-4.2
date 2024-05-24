extends CanvasLayer

@onready var resume = $menu/resume

func _ready():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		resume.grab_focus()

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
