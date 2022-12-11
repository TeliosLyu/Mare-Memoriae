extends Button

export var go_to_level = "main_menu"

func _pressed():
	Global.sfx_player.playing = true
	Global.goto_scene(go_to_level)
