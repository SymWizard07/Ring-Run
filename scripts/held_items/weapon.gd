class_name Weapon extends Node2D

@onready var swing_animation: SwingAnimation = $SwingAnimation
@onready var projectile_spawner: WeaponProjectileSpawner = $WeaponProjectileSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func swing(direction):
	swing_animation.swing()
	projectile_spawner.fire(direction)
	
func set_hand(hand):
	swing_animation.set_hand(hand)
