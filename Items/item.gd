extends Resource
class_name Item

@export var item_name: String = "Oggetto"
@export var cost: int = 0
@export var is_key: bool = false
@export var is_stackable: bool = true
@export var max_stack: int = 99
@export_category("Miscellanea")
@export var description: String = "Oggetto"
@export var icon: Texture2D

func effect():
	print("Nessun effetto")
