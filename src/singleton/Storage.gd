class_name GameStorage

var cities = []



func loadData():
	var file = File.new()
	if not file.file_exists("user://savegame.save"): return
	
	var content = file.get_as_text()
	var json = JSON.new()
	var result = json.parse(content)

	if not result == OK: return
	
	var data = json.get_data()

	if data.has("cities"):
		for city in data["cities"]:
			cities.append(GameCity.new(city))

	file.close()

func saveGame():
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)

	var data = {
		"cities": cities
	}

	file.store_line(to_json(data))

func addCities(name: String):
	cities.append({
		"name": name,
	})
	saveGame()