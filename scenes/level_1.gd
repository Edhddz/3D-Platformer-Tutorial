extends Node3D


func _ready() -> void:
	Global.coins = 0 # Reset number of collected coins on level load
	$HUD.get_node("CoinsLabel").text = str(Global.coins)
