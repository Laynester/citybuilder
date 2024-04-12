class_name CityChunk

var pos
var tiles = []
var unlocked = true
var unlocks
var unlockSprite
var map: TileMap
var check_adjacent
var chunk = []

signal bought;

var unlock_dupe
	
func _init(_start_pos, _tiles, _unlocked):
	pos = _start_pos
	tiles = _tiles
	unlocked = _unlocked

func done():
	if not unlocked:
		place_unlock()

func place_unlock():
	var map_pos = map.map_to_world(pos)
	var new_pos = Vector2(map_pos.x, map_pos.y + 96)
	unlock_dupe = unlockSprite.duplicate()
	unlock_dupe.show()
	unlock_dupe.set_position(new_pos)
	unlocks.add_child(unlock_dupe)

func try_buy(coords):
	var local_coords = [floor(coords.x), floor(coords.y)]

	if local_coords in tiles and not unlocked:
		unlock_chunk()

func unlock_chunk():
	if unlock_dupe:
		unlock_dupe.queue_free()
		unlock_dupe = null

	unlocked = true

	for tile in tiles:
		map.set_cell(tile[0],tile[1], 0)
	
	emit_signal("bought", chunk)
