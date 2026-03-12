extends Area2D

var MeleeHit = preload("res://Melee Hit.tscn")

var speed = 250
var player_owned = false
var hit_distance = 60
var respawn_time = 0
var respawn_time_max = 50
	
func spawn_melee_hit(weapon_holder, aim_vector):
	var new_melee_hit = MeleeHit.instantiate()
	get_tree().root.add_child(new_melee_hit)
	
	new_melee_hit.speed = speed
	new_melee_hit.global_position = weapon_holder.global_position + aim_vector * hit_distance
	new_melee_hit.rotation = aim_vector.angle() + PI / 2
	new_melee_hit.global_scale = weapon_holder.global_scale * 8
