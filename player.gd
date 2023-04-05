extends CharacterBody3D
var health = 200
var damage = 100
var speed = 10
var direction = Vector3() # to represent positions in 3D space 
var mouse_sens = 0.05#sets mouse sensitivity
var full_contact = false
var normal_accel = 6
var air_accel = 1
var gravity = 20
var jump = 10
var gravity_direction = Vector3()
var movement = Vector3()
var h_accel = 6
var h_vel = Vector3()
var controller_sens = 1
var weapons =[]
var weapon_dropped 
@onready var gun = $"Head/Gun"
@onready var head = $Head #uses the spatial node 'Head'
@onready var an_pl = $AnimationPlayer
@onready var camera = $Head/Camera3D
@onready var aimcast = $Head/Camera3D/RayCast3D
@onready var Pause = $PauseMenu
@onready var ground_check =$GroundCheck#Uses the ground check raycast node
var weapon_picked


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
func _ready():
	if not is_multiplayer_authority(): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED#Captures mouse input events in the window
		camera.current = true

		
func _unhandled_input(event):
	if not is_multiplayer_authority():
		if event.is_action_pressed("Pause"):
			Pause.is_paused = !Pause.is_paused
		var axis_vector = Vector2()
		axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		if InputEventJoypadMotion:
			rotate_y(deg_to_rad(-axis_vector.x) * controller_sens)
			head.rotate_x(deg_to_rad(-axis_vector.y) * controller_sens)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))#'event.relative.x' processes mouse movement and position changes in the
			#X axis relative to the player. multiplying it by the mouse sensitivity gives the change in the position of the FOV in degrees,
			#which is converted to radians to rotate the camera(Right, left)
			head.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))#does the same thing for the y axis relative to the player(up,down)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))#Just allows a range of camera motion 
			#to -89 degrees and 89 degrees so it does rotate 360 degrees 
func _physics_process(delta):
	if not is_multiplayer_authority():
					
		if gun.get_child_count() > 0:
			if Input.is_action_just_pressed("fire"):#checks if moouse button is clicked
				gun.get_child(0).fire(aimcast)
		
		direction = Vector3()
		
		full_contact = ground_check.is_colliding()
		
		
		if not is_on_floor():
			gravity_direction += Vector3.DOWN * gravity * delta#Gravity acts vertically, downwards when not on floor
			h_accel = air_accel
		elif is_on_floor() and full_contact:
			gravity_direction = Vector3.DOWN * gravity
			h_accel = normal_accel
		else:
			gravity_direction = -get_floor_normal()
			h_accel = normal_accel
			
		if Input.is_action_just_pressed("Jump") and (is_on_floor() or ground_check.is_colliding()):
			gravity_direction = Vector3.UP * jump # Jump action, gravity vector acts upwards in the magnitude of 'jump'
			
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z#when the move forward button is pressed, the direction of movement
			#would be the direction the player facing(Z axis)
		if Input.is_action_pressed("move_back"):# Opposite to the direction the player is facing
			direction += transform.basis.z
		if Input.is_action_pressed("move_left"):#To the left in X axis
			direction -= transform.basis.x
		if Input.is_action_pressed("move_right"):# To the right
			direction += transform.basis.x
			
		direction = direction.normalized()#prevents player from going faster diagonally
		
		
		h_vel = h_vel.lerp(direction*speed,h_accel*delta)# allows player to accelerate and decelerate realistically instead of stopping right away
		movement.z = h_vel.z + gravity_direction.z# resultant of the horizontal velocity and the gravity vector in the z axis
		movement.x = h_vel.x + gravity_direction.x# x axis
		movement.y = gravity_direction.y
		set_velocity(movement)
		set_up_direction(Vector3.UP)
		move_and_slide() #If the body collides with another, it will slide along the other body rather than stop immediately

func add_weapon(weapon_type):
	if weapon_type not in weapons:
		weapons.append(weapon_type)
		var weapon_scene = load("res://" + weapon_type + ".tscn")
		var weapon_instance = weapon_scene.instantiate()
		gun.add_child(weapon_instance)
