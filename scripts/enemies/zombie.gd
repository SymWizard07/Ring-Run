class_name Zombie extends Area2D

var speed = 80
var max_speed = 80
var velocity = Vector2.ZERO
var velocity_offset = Vector2.ZERO
@onready var player
var hurt_time = 0.0
var hurt_time_max = 0.4
var hurt_speed = 140
var health = 5

@export var separation_strength: float = 20.0
var separation_velocity: Vector2 = Vector2.ZERO

@onready var separation_area = $SeparationArea

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hurt_time > 0:
		hurt_time -= delta
	if hurt_time > 0:
		$AnimatedSprite2D.self_modulate = Color(255, 0, 0, 0.5)
	else:
		hurt_time = 0
		$AnimatedSprite2D.self_modulate = Color.WHITE
	
	if player != null && hurt_time <= 0:
		velocity = (player.get_position() - self.get_position())
		
	if velocity.length() > 0 && hurt_time <= 0:
		velocity = (velocity + velocity_offset).normalized() * speed
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	var total_push := Vector2.ZERO
	
	for area in separation_area.get_overlapping_areas():
		var other : Node2D = area.get_parent()
		
		if other == self:
			continue
		if not other.is_in_group("Enemy"):
			continue
		
		var push_dir := global_position - other.global_position
		
		# Fallback in case both are in exactly the same spot
		if push_dir.length_squared() == 0.0:
			push_dir = Vector2.RIGHT.rotated(randf() * TAU)
		else:
			push_dir = push_dir.normalized()
		
		total_push += push_dir

	if total_push.length_squared() > 0.0:
		separation_velocity = total_push.normalized() * separation_strength
	else:
		separation_velocity = Vector2.ZERO
	
	velocity += separation_velocity
	
	position += velocity * delta

func hurt(damage):
	if hurt_time == 0:
		health -= damage
		if health <= 0:
			queue_free()
		
		hurt_time = hurt_time_max
		velocity = velocity.normalized() * -1 * hurt_speed


func _on_area_entered(area):
	if area.is_in_group("Player"):
		area.hurt(0, self)
	if area.is_in_group("Enemy"):
		if hurt_time <= 0 && area.hurt_time <= 0:
			if rng.randi_range(0, 1) == 0:
				velocity_offset = Vector2.from_angle(velocity.angle() + deg_to_rad(45))
			else:
				velocity_offset = Vector2.from_angle(velocity.angle() - deg_to_rad(45))


#func _on_area_exited(area):
	#if area.is_in_group("Enemy"):
		#velocity_offset = Vector2.ZERO
