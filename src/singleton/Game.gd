extends Node2D

var Storage

func _ready():
	Storage = GameStorage.new()

func backToMenu():
	goto_scene("res://start/main-menu.tscn")

func game():
	return get_parent().get_node("GameMain")

func goto_scene(path):
	game().goto_scene(path)
