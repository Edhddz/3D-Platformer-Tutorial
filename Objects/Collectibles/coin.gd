extends Area3D

const ROT_SPEED: int = 2  # Number of degrees the coin rotates every frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(_body: Node3D) -> void:  # Built-in signal
	$AnimationPlayer.play("bounce")
