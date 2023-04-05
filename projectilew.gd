extends RigidBody3D
var dropped = false

@onready var Bullet = preload("res://bullet.tscn")
@onready var muzzle = $muzzle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dropped == true:
		apply_impulse(transform.basis.z, -transform.basis.z * 10)
		dropped = false
func fire(aimcast):
	if aimcast.is_colliding():#checks if the ray is colliding with an object
			var target = aimcast.get_collider()
			var bullet = Bullet.instantiate()
			muzzle.add_child(bullet)
			bullet.look_at(aimcast.get_collision_point(), Vector3.UP)
			bullet.shoot = true
			
