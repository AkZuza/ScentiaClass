extends KinematicBody
var gravity=-40
var speed=15
var jump_speed=25
var mouse_sensitivity=0.08
var move = true
var velocity=Vector3()
var puppet_position=Vector3()
var puppet_velocity=Vector3()
var g
var puppet_rotation=Vector2()
var camera2: Camera
var currentCameraIndex = 1
export(NodePath)onready var head=$head
export(NodePath)onready var model=$man/man
export(NodePath) onready var camera=$head/Camera
export(NodePath) onready var network_tick_rate=$NetworkTickRate
export(NodePath) onready var movement_tween=$MovementTween
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current= is_network_master()
	model.visible = !is_network_master()
	



func get_input():
	var input_dir=Vector3()
		
	
	if Input.is_action_pressed("move_forward"):
		input_dir+= -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir+= global_transform.basis.z
	if Input.is_action_pressed("move_right"):
		input_dir+= global_transform.basis.x
	if Input.is_action_pressed("move_left"):
		input_dir+= -global_transform.basis.x
	if Input.is_action_pressed("jump"):
		input_dir+= -global_transform.basis.z
		
	if Input.is_action_just_pressed("sit"):
		move = not move
		print(move)
		puppet_position=Vector3(0,0,0)	
		rotate_y(deg2rad(0))
		
		 
	input_dir=input_dir.normalized()
	if not move:
		input_dir = Vector3()
	return input_dir

func _input(event):
	if is_network_master():
		if event is InputEventMouseMotion and move:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			head.rotation.x=clamp(head.rotation.x,deg2rad(-90),deg2rad(0))		
	if event.is_action_pressed("ui_cancel"):
		if (Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else :
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _physics_process(delta):
	velocity.y+=gravity*delta
	if is_network_master():
		var desired_velocity=get_input()*speed
		velocity.x=desired_velocity.x
		velocity.z=desired_velocity.z
	
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y+=jump_speed
	else: 
		global_transform.origin=puppet_position
		velocity.x=puppet_velocity.x
		velocity.z=puppet_velocity.z
		rotation.y=puppet_rotation.y
		head.rotation.x=puppet_rotation.x
	if !movement_tween.is_active():
		velocity=move_and_slide(velocity,Vector3.UP,true)
	
puppet func update_state(p_position,p_velocity,p_rotation):
	puppet_position=p_position
	puppet_velocity=p_velocity
	puppet_rotation=p_rotation
	
	movement_tween.interpolate_property(self,"global_transform",global_transform,Transform(global_transform.basis,p_position),0.1)
	movement_tween.start()


func _on_NetworkTickRate_timeout():
	if is_network_master():
		rpc_unreliable("update_state",global_transform.origin,velocity,Vector2(head.rotation.x,rotation.y))
	else:
		network_tick_rate.stop()
func switch_camera():
	# Toggle between the two cameras
	if currentCameraIndex == 1:
		camera.current = false
		camera2.current = true
		currentCameraIndex = 2
	else:
		camera.current = true
		camera2.current = false
		currentCameraIndex = 1
