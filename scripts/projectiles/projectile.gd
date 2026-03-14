extends Node2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 400.0
var damage: int = 1
var velocity_curve: Curve
var can_damage: Array[String]

@onready var sprite: AnimatedSprite2D = $ProjectileArea/AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $ProjectileArea/CollisionShape2D
@onready var lifetime_timer: Timer = $Timer

func setup(config: ProjectileConfig, start_direction: Vector2) -> void:
	direction = start_direction.normalized()
	velocity_curve = config.velocity_curve
	speed = config.speed
	damage = config.damage
	rotation = start_direction.angle()
	
	sprite.sprite_frames = config.sprite_frames
	sprite.scale = config.scale
	sprite.rotation = deg_to_rad(config.sprite_rotation_offset)
	sprite.play(&"", 1 / config.lifetime)
	
	var shape := RectangleShape2D.new()
	shape.size = config.size * config.scale
	collision_shape.shape = shape
	
	can_damage = config.can_damage
	
	lifetime_timer.wait_time = config.lifetime
	lifetime_timer.timeout.connect(queue_free)
	lifetime_timer.start()

func _ready() -> void:
	$ProjectileArea.area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if lifetime_timer == null or velocity_curve == null:
		global_position += direction * speed * delta
		return

	var total_time := lifetime_timer.wait_time
	if total_time <= 0.0:
		global_position += direction * speed * delta
		return

	var elapsed := total_time - lifetime_timer.time_left
	var t := clampf(elapsed / total_time, 0.0, 1.0)

	var current_speed := speed * velocity_curve.sample(t)
	global_position += direction * current_speed * delta
	
func _on_area_entered(area):
	for group in can_damage:
		if area.is_in_group(group) and area.has_method("hurt"):
			area.hurt(damage)
