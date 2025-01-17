extends KinematicBody

const GRAVITY = -24
var vel = Vector3()
const MAX_SPEED = 15
const JUMP_SPEED = 100
const ACCEL = 20
const DEACCEL= 20
const MAX_SLOPE_ANGLE = 40
var MOUSE_SENSITIVITY = 0.05

var velocity = Vector3.ZERO;
var dir = Vector3();

var camera;
var rotation_helper;

func _ready():
	camera = $Pivot/Camera
	rotation_helper = $Pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	process_input(delta)
	process_movment(delta)
	
	
func process_input(_delta):
	var cam_xform = camera.global_transform;
	var input_movement_vector = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_back"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x	
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	
func process_movment(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	dir = Vector3()
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(-1 * event.relative.y * MOUSE_SENSITIVITY))
		#camera.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
		
	if event.is_action_pressed("ui_cancel"):
		if (Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else :
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

