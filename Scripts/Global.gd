extends Node

# Music mute toggle
var is_muted = false

# Sound effect
var sfx_player

# Scene loader
var current_scene = null
var root

# Load all level scenes into array
const main_menu = ("res://Scenes/Levels/Main_Menu.tscn")
const level_1 = ("res://Scenes/Levels/Level_1.tscn")
const level_2 = ("res://Scenes/Levels/Level_2.tscn")
const level_3 = ("res://Scenes/Levels/Level_3.tscn")
const tutorial = ("res://Scenes/Levels/Tutorial.tscn")
const level_select = ("res://Scenes/Levels/Level_Select.tscn")
const credits = ("res://Scenes/Levels/Credits.tscn")

# Dictionary between strings and real paths
var level_dict = {
	"main_menu" : main_menu,
	"level_1" : level_1,
	"level_2" : level_2,
	"level_3" : level_3,
	"tutorial" : tutorial,
	"level_select" : level_select,
	"credits" : credits,
}
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	sfx_player = root.get_child(root.get_child_count() - 2)
	
func goto_scene(dict_key):
	# Defer the scene switch until the current scene has finished running
	call_deferred("_defered_goto_scene", level_dict[dict_key])
	
func _defered_goto_scene(path):
	# Now safe to remove the current scene
	root.remove_child(current_scene)
	current_scene.free()
	
	# Load new scene
	var new_scene = ResourceLoader.load(path)
	
	# Instance the new scene
	current_scene = new_scene.instance()
	
	# Add it ot the active scene as a child of root
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
