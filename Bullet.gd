extends RigidBody3D

var shoot = false
var damage = 100
const speed = 0.1
func _ready():
	set_as_top_level(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z,-transform.basis.z)


func _on_area_3d_body_entered(body):
	if body.is_in_group('Player'):
		body.health = body.health - damage
		queue_free()
	else:
		queue_free()
