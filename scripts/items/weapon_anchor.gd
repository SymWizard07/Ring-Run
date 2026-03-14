extends Node2D

@export var bob_height: float = 1.0
@export var bob_time: float = 1.0

var start_position: Vector2
var time_passed: float = 0.0

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time_passed += delta
	
	var offset = sin(time_passed * TAU / bob_time) * bob_height
	position.y = start_position.y + offset
