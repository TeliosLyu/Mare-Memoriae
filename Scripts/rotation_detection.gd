extends Area2D

signal clicked 

onready var _parent = get_node("..")

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.get_button_index() == 1 and event.is_pressed():
		emit_signal("clicked")
