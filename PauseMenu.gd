extends Control

var is_paused = false : set = set_is_paused# define a variable 'is_paused' and a setter method 'set_is_paused' to access it


func _ready():
	visible = false# set the visibility of the control node to false initially

func set_is_paused(value):
	is_paused = value# set the 'is_paused' variable to the passed in value
	get_tree().paused = is_paused# set the game's paused state to the 'is_paused' value
	visible = is_paused# set the visibility of the control node to true if 'is_paused' is true, otherwise false
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # if the pause menu is visible, set the mouse mode to visible
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)# otherwise set it to captured 
func _on_ResumeB_pressed():
	self.is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # set the mouse mode to captured 

func _on_QuitB_pressed():
	get_tree().quit()# when the 'Quit' button is pressed, quit the game
