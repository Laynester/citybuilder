extends Node2D

onready var map: TileMap = $TileMap
onready var unlockSprite = $Unlocks/UnlockSprite
onready var unlocks = $Unlocks


var chunks = [
	[0, 0]
]

var local_chunks = []

var chunk_size = 6

func _ready():
	build_map()

func build_map():
	for chunk in chunks:
		place_chunk_at(chunk[0] * chunk_size, chunk[1] * chunk_size, 0)
		check_adjacent(chunk[0], chunk[1])

func check_adjacent(x,y):
	check_and_place_adjacent_chunk(x - 1, y, 1)
	check_and_place_adjacent_chunk(x, y - 1, 1)
	check_and_place_adjacent_chunk(x + 1, y, 1)
	check_and_place_adjacent_chunk(x, y + 1, 1)

func check_and_place_adjacent_chunk(x, y, index):
	if not chunkExists(floor(x),floor(y)):
		place_chunk_at(x * chunk_size, y * chunk_size, index)
	
func place_chunk_at(x, y, index):
	var tiles = []
	for cs in range(chunk_size):
		for cs2 in range(chunk_size):
			map.set_cell(x + cs, y + cs2, index)
			tiles.append([floor(x + cs), floor(y + cs2)])

	var chunk = CityChunk.new(Vector2(x,y), tiles, (index == 0))

	chunk.unlocks = unlocks
	chunk.unlockSprite = unlockSprite
	chunk.map = map
	chunk.chunk = [floor(x / 6), floor(y / 6)]
	chunk.connect("bought", self, "on_bought_chunk")
	chunk.done()

	local_chunks.append(chunk)


var clicked = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			on_left_mouse_click(event.position)

func on_left_mouse_click(_mouse_position):
	var tileCoords = map.world_to_map(get_global_mouse_position())

	var tile = map.get_cellv(tileCoords)

	if tile == -1: return

	try_buy_plot(tileCoords)

func try_buy_plot(coords):
	for chunk in local_chunks:
		chunk.try_buy(coords)

func on_bought_chunk(chunk):
	chunks.append(chunk)
	check_adjacent(chunk[0], chunk[1])

func chunkExists(x,y):
	var exists = false

	for chunk in local_chunks:
		if chunk.chunk == [x,y]:
			exists = true 

	return exists
