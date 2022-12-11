extends Control

onready var pause_screen = get_node("Pause")

func _input(event):
	if event.is_action_pressed("pause"):
		pauseToggle()

func _on_main_menu_pressed():
	pauseToggle()

func _pressed():
	Global.sfx_player.playing = true
	pauseToggle()

func _on_resume_pressed():
	pauseToggle()

func pauseToggle():
	Global.sfx_player.playing = true
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	if get_tree().paused:
		pause_screen.show()
	else:
		pause_screen.hide()

