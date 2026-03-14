class_name SwingAnimation extends Node2D


@export var swing_speed = 0.5
var reset_delay = 0.8
var reset_time = 0
var desired_rot = 0
var hand = "right"
var done = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = lerp_angle(rotation, deg_to_rad(desired_rot), 0.1)
	if is_equal_approx(rotation, deg_to_rad(desired_rot)):
		done = true
	else:
		done = false
	
func set_hand(hand):
	if hand == "right" && self.hand != "right":
		rotation_degrees = -80
		desired_rot = 20
	elif hand == "left" && self.hand != "left":
		rotation_degrees = 190
		desired_rot = 80
	
	self.hand = hand

func swing():
	if hand == "right":
		if self.rotation_degrees < 0:
			desired_rot = 20
		elif self.rotation_degrees >= 0:
			desired_rot = -80
	elif hand == "left":
		if self.rotation_degrees >= 90:
			desired_rot = 80
		elif self.rotation_degrees < 90:
			desired_rot = 190
