extends Node2D

signal goal_reached

export var is_active = false
export var is_static = false

# type_id:
#	0 - null tile
#	1 - start tile
#	2 - end tile
#	3 - straight tile
#	4 - curve tile
export var type_id = 0

onready var connections_handler = get_node("connections")
onready var connections = connections_handler.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var rotation_detector = get_node("rotation_detection")
	rotation_detector.connect("clicked", self, "_on_clicked")
	
	# Set this tile to static if it's a null tile
	if type_id == 0:
		is_static = true
	
	# Set this tile to on
	if type_id == 1:
		is_active = true
	
	updateSprite()

# Rotation handler
func _on_clicked():
	if not is_static:
		rotation_degrees += float(90)
		Global.sfx_player.playing = true

func _physics_process(_delta):
	updateSprite()
	# If this isn't source tile
	if type_id != 1:
		# Set tile to off
		updateState(false)
	# Propagate from source
	spill()

# Code to propagate the connection from the source
func spill():
	# If tile is from the source
	if type_id == 1:
		# Get all the Area2D that overlaps with this pipe's connections
		var overlaps = connections_handler.get_overlapping_areas()
		# For every Area2D overlap
		for i in overlaps:
			# Check only for connection-handling Area2D
			if i.name == "connections":
				# Turn the tile on
				i.owner.updateState(true)
				# Call fill() to propagate the state to the rest of the tiles
				i.owner.fill()

# Code to propagate the connection from non-source tiles
func fill():
	# Get all the Area2D that overlaps with this pipe's connections
	var overlaps = connections_handler.get_overlapping_areas()
	# For every Area2D overlap
	for i in overlaps:
		# Check only for connection-handling Area2D and then check if the adjacent connected tile is not active
		if i.name == "connections" and !i.owner.is_active:
			# Turn the tile on
			i.owner.updateState(true)
			# Call fill() to propagate the state to the rest of the tiles
			i.owner.fill()

func updateState(input):
	if !(type_id == 1 or type_id == 0):
		is_active = input
	updateSprite()

func updateSprite():
	# Handling source tile
	if type_id == 1 :
		if !is_static:
			get_node("conduit_sprite").set_frame(0)
		else:
			get_node("conduit_sprite").set_frame(1)
	# Handling any tiles that aren't source and null tiles
	elif type_id != 0:
		# Is not a static tile
		# Is not active
		if !is_static and !is_active:
			get_node("conduit_sprite").set_frame(0)
		# Is active
		elif !is_static and is_active:
			get_node("conduit_sprite").set_frame(1)
		# Is a static tile
		# Is not active
		elif is_static and !is_active:
			get_node("conduit_sprite").set_frame(2)
		# Is not active
		elif is_static and is_active:
			get_node("conduit_sprite").set_frame(3)
