extends Resource
class_name Ability

@export var ability_name: String = "Magic"
@export var type: Library.Type = Library.Type.HEALING
@export var element: Library.Element = Library.Element.BLUDEGONING

@export var damage: float = 0
@export var cost: float = 0

@export_group("Miscellanea")
@export var description: String = 'N/D'
@export var icon: Texture


func effect():
	pass
