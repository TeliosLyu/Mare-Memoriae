extends Button

var music_bus = AudioServer.get_bus_index("Music")
onready var bgm = get_node("/root/Global")

func _on_BGM_Toggle_pressed():
	mute_toggle()

func _input(event):
	if event.is_action_pressed("bgm_mute_toggle"):
		mute_toggle()

func mute_toggle():
	Global.sfx_player.playing = true
	bgm.is_muted = !bgm.is_muted
	if bgm.is_muted:
		text = "Unmute Music"
		AudioServer.set_bus_mute(music_bus, true)
	else:
		text = "Mute Music"
		AudioServer.set_bus_mute(music_bus, false)
	
