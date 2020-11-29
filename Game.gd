extends Spatial


onready var next_cube_timer = $NextCubeTimer
onready var HUD = $HUD


var cube = null
var score = 0
var highest_cube_value = 0
var is_dragging = false


# on mobile we want to make sure we don't shoot cubes when user is pulling down
# notifications/performing a home gesture
func get_save_zone_size():
	var platform = OS.get_name()

	if platform == "Android" or platform == "iOS":
		return 40
	else:
		return 0

func _ready():
	randomize()
	create_new_cube()

	HUD.set_score(0)

func _input(event):
	if cube == null:
		return

	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if is_dragging:
			drag_current_cube(event)

	if event is InputEventScreenTouch and !event.pressed:
		if is_dragging:
			shoot_new_cube()

	if event is InputEventScreenTouch:
		if event.pressed and not event_in_safe_zone(event):
			is_dragging = event.pressed
		else:
			is_dragging = false

func event_in_safe_zone(event):
	var safe_zone_size = get_save_zone_size()

	if safe_zone_size == 0:
		return false

	var pos = event.position
	return pos.y <= safe_zone_size or pos.y >= get_viewport().size.y - safe_zone_size

func shoot_new_cube():
	cube.apply_central_impulse(Vector3(0, 0, -15))
	cube = null
	next_cube_timer.start()

func drag_current_cube(event):
	var viewport = get_viewport()

	var vp_w = viewport.size.x
	var mouse_pos = event.position
	var cube_pos = cube.global_transform.origin
	var cube_w = cube.scale.x + 0.1
	var cube_half_w = cube_w / 2
	
	var percent = mouse_pos.x / vp_w
	var cube_x = -2 + (4 * percent)
	cube_x = clamp(cube_x, -2 + cube_half_w, 2 - cube_half_w)
	
	cube.global_transform.origin = Vector3(cube_x, cube_pos.y, cube_pos.z)

func create_new_cube():
	var Cube = load("res://Cube.tscn")
	cube = Cube.instance()
	cube.connect("on_cubes_merged", self, "_on_Cube_on_cubes_merged")
	cube.sleeping = true
	cube.global_transform.origin = Vector3(0, 0.874, 3.655)
	add_child(cube)
	check_highest_cube_value(cube.value)

func check_highest_cube_value(value):
	highest_cube_value = max(highest_cube_value, value)
	HUD.set_highest_cube_value(highest_cube_value)

func _on_NextCubeTimer_timeout():
	create_new_cube()

func _on_Cube_on_cubes_merged(value):
	score += value

	check_highest_cube_value(value)
	HUD.set_score(score)
