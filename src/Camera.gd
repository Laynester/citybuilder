extends Camera2D

var pan_speed: float = 1.0


var start_zoom: Vector2
var start_dist: float
var touch_points: Dictionary = {}
var start_angle: float
var current_angle: float
var panning = false


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			pan_camera()
	elif event is InputEventMouseMotion:
		update_camera_position(event.relative)
	elif event is InputEventMouseButton and not event.pressed:
			panning = false
	

func _handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		var _pts = touch_points.erase(event.index)
		
	if touch_points.size() < 2:
		start_dist = 0

func _handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
		
	if touch_points.size() == 1:
		offset -= event.relative * pan_speed


func pan_camera():
	panning = true
		
func update_camera_position(relative_position):
	if panning:
		offset -= relative_position
