extends Node2D

var Zombie = preload("res://Zombie.tscn")
var viewport_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))

@onready var player = get_parent().get_node("Player")

var wave_timer = 0
var next_wave_time = 2

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wave_timer <= 0:
		spawn_wave()
		wave_timer = next_wave_time
		
	wave_timer -= delta

func spawn_wave():
	var zombie = Zombie.instantiate()
	zombie.player = player
	var side = rng.randi_range(0, 3)
	if side == 0:
		zombie.position.x = -30
		zombie.position.y = rng.randi_range(0, viewport_size.y)
	elif side == 1:
		zombie.position.x = viewport_size.x + 30
		zombie.position.y = rng.randi_range(0, viewport_size.y)
	elif side == 2:
		zombie.position.x = rng.randi_range(0, viewport_size.x)
		zombie.position.y = -30
	elif side == 3:
		zombie.position.x = rng.randi_range(0, viewport_size.x)
		zombie.position.y = viewport_size.y + 30
		
	get_tree().root.add_child(zombie)
