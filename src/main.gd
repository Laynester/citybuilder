extends Node2D

onready var anim = $AnimationPlayer
onready var colorRect: ColorRect = $CanvasLayer/ColorRect

var current_scene
var queued_scene

func _ready():
	setupColorRect()
	goto_scene("res://src/main-menu/MainMenu.tscn")

func goto_scene(path):
	var s = ResourceLoader.load(path)
		
	queued_scene = s.instance()

	print(path)

	if current_scene: anim.play("fade_in")
	else: setNewScene()

func setNewScene():
	$YSort.add_child(queued_scene)
	if current_scene: current_scene.queue_free()
	current_scene = queued_scene
	queued_scene = null
	anim.play("fade_out")

func setupColorRect():
	var w = get_viewport_rect().size.x
	var h = get_viewport_rect().size.y

	colorRect.rect_size.x = w
	colorRect.rect_size.y = h
	
	colorRect.material.set_shader_param('screen_width', w)
	colorRect.material.set_shader_param('screen_height', h)


func _on_AnimationPlayer_animation_finished(anim_name:String):
	match anim_name:
		"fade_in":
			setNewScene()
