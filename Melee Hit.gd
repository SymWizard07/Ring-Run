class_name MeleeHit extends Area2D

var id = "MeleeHit"

var speed = 0
var player_created = true

func _ready():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("slash")

func _process(delta):
	self.position += Vector2.UP.rotated(rotation) * speed * delta
		
	if $AnimatedSprite2D != null && $AnimatedSprite2D.frame == 4:
		queue_free()


func _on_area_entered(area):
	match area.id:
		"Zombie":
			area.hurt(2)
