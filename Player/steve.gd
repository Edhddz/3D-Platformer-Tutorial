extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12
const ROTATION_SMOOTHING = 0.3  # Adjust this for smoother/faster transitions
var xForm : Transform3D
var last_floor_normal := Vector3.UP  # Store previous normal for smooth transitions

func _physics_process(delta: float) -> void:
	
	# Rotate the camera left / right
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-22.5))
	
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(22.5))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = ($CameraController.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate character to its moving direction
	if input_dir != Vector2.ZERO:
		$MeshInstance3D.rotation_degrees.y = $CameraController.rotation_degrees.y - rad_to_deg(input_dir.angle()) - 90
	
	# Update RayCast3D to follow position but keep independent rotation
	$RayCast3D.global_position = global_position
	$RayCast3D.rotation = Vector3.ZERO  

	# Smooth transition between different floor angles
	if is_on_floor():
		var current_normal = $RayCast3D.get_collision_normal()
		last_floor_normal = last_floor_normal.lerp(current_normal, ROTATION_SMOOTHING)  # Smooth the transition
	else:
		last_floor_normal = last_floor_normal.lerp(Vector3.UP, ROTATION_SMOOTHING)

	# Apply rotation smoothing
	align_with_floor(last_floor_normal)
	global_transform = global_transform.interpolate_with(xForm, 0.4)

	# Update velocity and move character
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Make camera controller match player position
	$CameraController.position = lerp($CameraController.position, position, 0.15)
	
func align_with_floor(floor_normal) -> void:
	xForm = global_transform
	xForm.basis.y = floor_normal
	xForm.basis.x = -xForm.basis.z.cross(floor_normal)
	xForm.basis = xForm.basis.orthonormalized()


func _on_death_zone_body_entered(_body: Node3D) -> void:
	get_tree().call_deferred("reload_current_scene")
