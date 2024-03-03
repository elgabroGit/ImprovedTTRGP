extends Node2D

var enemies

func _ready() -> void:
	enemies = get_children()
	var i = 0
	for enemy in enemies:
		enemy.position = Vector2(-60 * i, 130 * i)
		i += 1

func _process(_delta: float) -> void:
	enemies = get_children()
