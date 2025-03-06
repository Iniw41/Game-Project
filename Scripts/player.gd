extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $twist_pivot
@onready var pitch_pivot := $twist_pivot/pitch_pivot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Movement of the player
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "mover_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(twist_pivot.basis * input * 1200 * delta)
	
	#Showing the cursor
	if Input.is_action_pressed("show_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_released("show_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	#Mouse Output into Camera
	$twist_pivot.rotate_y(twist_input)
	$twist_pivot/pitch_pivot.rotate_x(pitch_input)
	$twist_pivot/pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,
	deg_to_rad(-30),
	deg_to_rad(30)
	)
	
	twist_input = 0.0
	pitch_input = 0.0

#Mouse Input into Camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity 
