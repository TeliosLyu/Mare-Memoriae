extends Node

signal stage_complete

onready var tilemap = get_node("game_grid")
const null_tile = preload("res://Scenes/conduit_null.tscn")
const source_tile = preload("res://Scenes/conduit_source.tscn")
const goal_tile = preload("res://Scenes/conduit_goal.tscn")
const straight_tile = preload("res://Scenes/conduit_straight.tscn")
const curve_tile = preload("res://Scenes/conduit_curve.tscn")
const tiles = [null_tile, source_tile, goal_tile, straight_tile, curve_tile]

var tiles_array
var goal_tiles = []
var goal_bools = []
var goal_check = 0
var goal_cur = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tiles_array = tilemap.get_used_cells() 
	instantiateTiles()
	
	# Instantiate goal_bools with state of all goal tiles
	for i in goal_tiles:
		goal_bools.append(i.is_active)

func _process(_delta):
	# Update goal_bools with state of all goal tiles
	var index = 0
	for i in goal_tiles:
		if i.is_active:
			goal_bools[index] = true
		else:
			goal_bools[index] = false
		index += 1
	
	# If all goal tiles are lit up
	if not false in goal_bools:
		emit_signal("stage_complete")

func instantiateTiles():
	var source_tiles = []
	for tilepos in tiles_array:
		var tile = tilemap.get_cellv(tilepos)
		var object
		match tile:
			# Null Tile
			0:
				# Instantiate the tile
				object = tiles[0].instance()
				formatTile(object, tilepos)
			# Source tile
			1, 2:
				# Capture these to instantiate them last
				source_tiles.append(tilepos)
			# Goal tile
			3, 4:
				# Instantiate the tile
				object = tiles[2].instance()
				# Update static flag
				if tile == 4:
					object.is_static = true
				formatTile(object, tilepos)
				# Capture goal tiles for win-checking later
				goal_tiles.append(object)
				goal_check += 1
				object.connect("goal_reached", self, "_on_goal")
			# Straight tile
			5, 6:
				# Instantiate the tile
				object = tiles[3].instance()
				# Update static flag
				if tile == 6:
					object.is_static = true
				formatTile(object, tilepos)
			# Curve tile
			7, 8:
				# Instantiate the tile
				object = tiles[4].instance()
				# Update static flag
				if tile == 8:
					object.is_static = true
				formatTile(object, tilepos)
	# Now instantiate the source tiles
	for tilepos in source_tiles:
		var tile = tilemap.get_cellv(tilepos)
		var object
		# Instantiate the tile
		object = tiles[1].instance()
		# Update static flag
		if tile == 2:
			object.is_static = true
		formatTile(object, tilepos)

func formatTile(object, tilepos):
	# Name the tile
	object.name = "Tile ({},{})".format([tilepos.x, tilepos.y], "{}")
	# Move tile to position
	var newpos = Vector2(tilemap.map_to_world(tilepos).x + 30, tilemap.map_to_world(tilepos).y + 30)
	object.position = newpos * tilemap.scale
	# Update tile scale
	object.scale = object.scale * tilemap.scale
	# Rotate tile to reflect the tile on the tilemap
	if !tilemap.is_cell_x_flipped(tilepos.x, tilepos.y):
		if !tilemap.is_cell_y_flipped(tilepos.x, tilepos.y) and !tilemap.is_cell_transposed(tilepos.x, tilepos.y):
			object.rotation_degrees = 0
		elif tilemap.is_cell_y_flipped(tilepos.x, tilepos.y) and tilemap.is_cell_transposed(tilepos.x, tilepos.y):
			object.rotation_degrees = 270
	else:
		if !tilemap.is_cell_y_flipped(tilepos.x, tilepos.y) and tilemap.is_cell_transposed(tilepos.x, tilepos.y):
			object.rotation_degrees = 90
		elif tilemap.is_cell_y_flipped(tilepos.x, tilepos.y) and !tilemap.is_cell_transposed(tilepos.x, tilepos.y):
			object.rotation_degrees = 180
	# Add the tile as a child to the level
	self.add_child(object)
	# Remove the TileMap texture
	tilemap.set_cellv(tilepos, -1)

func debugPrintArray():
	for i in range(tiles_array.size()):
		var cur_x = tiles_array[i].x;
		var cur_y = tiles_array[i].y;
		var report = ("Tile ({},{}): \nIs flipped on X axis: {} \nIs flipped on Y axis: {} \nIs transposed: {}".format([cur_x, cur_y, tilemap.is_cell_x_flipped(cur_x, cur_y), tilemap.is_cell_y_flipped(cur_x, cur_y), tilemap.is_cell_transposed(cur_x, cur_y)], "{}"));
		print(report);
