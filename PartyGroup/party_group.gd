extends Node2D

var party

func _ready() -> void:
	party = get_children()
	var i = 0
	for player in party:
		player.position = Vector2(60 * i, 130 * i)
		i += 1
