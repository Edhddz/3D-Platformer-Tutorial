extends CharacterBody3D

const SPEED = 3.0
@export var direction := Vector3(0, 0, 0)
const turning_time := 0.6
var is_turning := false  # Prevent multiple rotations
const rotation_amount := Vector3(0, 180, 0)

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * direction.x
	velocity.z = SPEED * direction.z

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

	# Only turn if not already turning
	if is_on_wall() and not is_turning:
		await turn_around()

func turn_around() -> void:
	is_turning = true
	#var dir = direction
	#direction = Vector3.ZERO  # No need to stop the movement since Redot will stop the movement by collision resolution

	var turn_tween = create_tween()
	turn_tween.tween_property(self, "rotation_degrees", rotation_amount, turning_time).as_relative()
	await get_tree().create_timer(turning_time).timeout

	direction = -direction

	is_turning = false  # Allow turning again, prevents a bug where the enemy turns twice and then stops moving when lowering SPEED
