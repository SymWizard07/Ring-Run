# ProjectileSpawner.gd
class_name WeaponProjectileSpawner extends Node2D

@export var projectile_scene: PackedScene
@export var projectile_config: ProjectileConfig
@onready var spawn_location: Node2D = $SpawnLocation

func fire(direction: Vector2) -> void:
	if projectile_scene == null or projectile_config == null:
		return
	
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	if projectile is Node2D:
		projectile.global_transform = spawn_location.global_transform
	
	projectile.setup(projectile_config, direction)
