extends Node2D

var players

func _ready() -> void:
	players = get_children()
	var i = 0
	for player in players:
		player.position = Vector2(60 * i, 130 * i)
		player.scale.x = -1
		player.health_label.scale.x = -1
		player.stamina_label.scale.x = -1
		i += 1

func _process(_delta: float) -> void:
	players = get_children()
