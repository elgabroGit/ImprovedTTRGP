extends CharacterBody2D

@onready var focus_sprite: Sprite2D = $Focus
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthLabel

@export_category("Generals")
@export var is_enemy: bool = true
@export_category("Stats")
@export var MAX_HEALTH: float = 10
var health: float
@export var MAX_SPEED: float = 10
var speed: float
@export var MAX_ATTACK: float = 10
var attack: float
@export var MAX_DEFENSE: float = 2
var defense: float


func _ready() -> void:
	focus_sprite.hide()
	health = MAX_HEALTH
	speed = MAX_SPEED
	attack = MAX_ATTACK
	defense = MAX_DEFENSE

func _process(_delta: float) -> void:
	_update_health_bar()
	_update_health_label()

func _update_health_bar() -> void:
	health_bar.value = (health/MAX_HEALTH) * 100
	
func _update_health_label() -> void:
	health_label.text = str(health) + '/' + str(MAX_HEALTH) 
	
func toggle_focus():
	if focus_sprite.visible:
		focus_sprite.hide()
	else:
		focus_sprite.show()
		
func focus():
	focus_sprite.show()
	
func unfocus():
	focus_sprite.hide()
	
