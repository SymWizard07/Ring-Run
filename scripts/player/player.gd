extends Area2D

signal hit

var id = "Player"

var Mace = preload("res://scenes/holdable/Mace.tscn")

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var velocity = Vector2.ZERO
# Magnitude of weapon vector sightline
var weapon_accuracy = 100
var respawn_time = 0
var respawn_time_max = 0.6
var hurt_time = 0.0
var hurt_time_max = 0.1
var hurt_speed = 800
var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	weapon = Mace.instantiate()
	add_child(weapon)
	set_weapon_hand("right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hurt_time > 0:
		hurt_time -= delta
	if hurt_time > 0:
		$AnimatedSprite2D.self_modulate = Color(255, 0, 0, 0.5)
	else:
		hurt_time = 0
		$AnimatedSprite2D.self_modulate = Color.WHITE
	
	if hurt_time == 0:
		velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
	
	position += velocity * delta
	
	if respawn_time > 0:
		respawn_time -= delta
	
	if $Sightline.get_aim_vector().x < 0:
		set_weapon_hand("right")
	elif $Sightline.get_aim_vector().x > 0:
		set_weapon_hand("left")
	
	if Input.is_action_pressed("attack") && respawn_time <= 0:
		weapon.swing($Sightline.get_aim_vector().normalized())
		respawn_time = respawn_time_max

func get_weapon_accuracy():
	return weapon_accuracy
	
func set_weapon_hand(hand):
	if hand == "left":
		weapon.position = $LeftHand.position
	else:
		weapon.position = $RightHand.position
	weapon.set_hand(hand)

func hurt(damage, damage_source):
	if hurt_time == 0:
		hurt_time = hurt_time_max
		velocity = (damage_source.position - self.position) * -1 * hurt_speed
