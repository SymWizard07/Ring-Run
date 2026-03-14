extends Resource
class_name ProjectileConfig

@export var sprite_frames: SpriteFrames
@export_range(-180, 180, 1, "degrees") var sprite_rotation_offset: float
@export var size: Vector2 = Vector2(20.0, 20.0)
@export var lifetime: float = 2.0
@export var speed: float = 500.0
## Projectile's velocity determined over it's lifetime by sampling curve
@export var velocity_curve: Curve
@export var damage: int = 1
@export var scale: Vector2 = Vector2.ONE
## Groups the projectile can deal damage to.
@export var can_damage: Array[String]
