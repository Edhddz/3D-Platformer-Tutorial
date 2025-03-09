extends Area3D

const ROT_SPEED: int = 2  # Number of degrees the coin rotates every frame
@export var hud: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(_body: Node3D) -> void:  # Built-in signal
	disable_coin_collision()
	update_coins()
	$AnimationPlayer.play("bounce")
	

func update_coins():
	Global.coins += 1
	hud.get_node("CoinsLabel").text = str(Global.coins)

func disable_coin_collision():
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
	
	if Global.coins >= Global.NUM_COINS_TO_WIN:
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
