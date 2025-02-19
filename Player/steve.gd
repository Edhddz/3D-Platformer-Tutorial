extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 12


func _physics_process(delta: float) -> void:
	
	# Rotate the camera left / right
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-22.5));
	
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(22.5));
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# New Vector3 direction, considering both input and camera rotation
	var direction = ($CameraController.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate character to it's moving direction
	if input_dir != Vector2(0, 0):
		$MeshInstance3D.rotation_degrees.y = $CameraController.rotation_degrees.y - rad_to_deg(input_dir.angle()) - 90
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	# Make camera controller match player position
	$CameraController.position = lerp($CameraController.position, position, 0.15)
