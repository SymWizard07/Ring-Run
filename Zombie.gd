class_name Zombie extends Area2D

var id = "Zombie"

var speed = 80
var max_speed = 80
var velocity = Vector2.ZERO
var velocity_offset = Vector2.ZERO
@onready var player
var hurt_time = 0.0
var hurt_time_max = 0.4
var hurt_speed = 140
var health = 5

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
	
	position += velocity * delta

func hurt(damage):
	if hurt_time == 0:
		health -= damage
		if health <= 0:
			queue_free()
		
		hurt_time = hurt_time_max
		velocity = velocity.normalized() * -1 * hurt_speed


func _on_area_entered(area):
	match area.id:
		"Player":
			area.hurt(0, self)
		"Zombie":
			if hurt_time <= 0 && area.hurt_time <= 0:
				if rng.randi_range(0, 1) == 0:
					velocity_offset = Vector2.from_angle(velocity.angle() + deg_to_rad(45))
				else:
					velocity_offset = Vector2.from_angle(velocity.angle() - deg_to_rad(45))
				print (velocity_offset)


func _on_area_exited(area):
	match area.id:
		"Zombie":
			velocity_offset = Vector2.ZERO
