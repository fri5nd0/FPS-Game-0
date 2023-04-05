extends RigidBody3D

var dropped = true
@export var weapon_type = 'hitscangun'

func fire(aimcast):
	var damage = 100
	print("gun fired")
	if aimcast.is_colliding():#checks if the ray is colliding with an object
			var target = aimcast.get_collider()
			if target.is_in_group("Player"):#checks if the collision is with a object that is in the group 'enemy'
					print("hit enemy")#just so we know the ray cast is colliding(for test)
					target.health -= damage#reduces player health
	await get_tree().create_timer(500).timeout




func _on_hw_pickup_area_body_entered(body):
	if dropped == true:
		if body!=null and body.is_in_group("Player"):
			var player = body
			if Input.is_action_just_pressed("interact"):
				player.add_weapon(weapon_type)
				set_physics_process(false)
				dropped = false
			
