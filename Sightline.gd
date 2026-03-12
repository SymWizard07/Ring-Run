extends Line2D

var viewport_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

var player = get_parent()
var aim_vector = Vector2.ZERO
var aim_length = 300
var mouse_moved = false
var using_mouse = false
@export var num_sightdots = 10
@onready var sightdots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_sightdots:
		var new_sightdot = get_node("Sightdot").duplicate()
		new_sightdot.visible = true
		sightdots.append(new_sightdot)
		self.add_child(new_sightdot)

func _process(delta):
	self.set_point_position(0, self.position)
	
	aim_vector = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
	if aim_vector.distance_to(Vector2.ZERO) <= 0.1 && mouse_moved:
		aim_vector = (get_viewport().get_mouse_position() - self.get_global_transform_with_canvas().get_origin()) * ((viewport_size.x / viewport_size.y) + 1)
		using_mouse = true
	else:
		mouse_moved = false
		using_mouse = false
	
	if (aim_vector.distance_to(Vector2.ZERO) > 0.2):
		if !using_mouse: 
			aim_vector *= aim_length
	
		self.set_point_position(1, self.position + aim_vector)
	
		for i in sightdots.size():
			sightdots[i].visible = true
			var point_distance = ((self.get_point_position(1) - self.get_point_position(0)) / sightdots.size())
			sightdots[i].position = point_distance * i
	else:
		for sightdot in sightdots:
			sightdot.visible = false

func get_aim_vector():
	return aim_vector
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_moved = true
