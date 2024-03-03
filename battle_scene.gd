extends Node2D

@onready var action_buttons: VBoxContainer = $UI/ActionButtons
@onready var enemy_group: Node2D = $EnemyGroup
@onready var party_group: Node2D = $PartyGroup

var action_queue: Array
var enemies: Array
var players: Array

var selected_action_index: int = 0
var selected_enemy_index: int = 0
var current_battle_state: Library.BattleState = Library.BattleState.NONE

var current_player_selected_index: int = 0

signal signal_action_select
signal signal_enemy_select
signal signal_action_attack
signal signal_move_selection_cursor
signal signal_target_selected

func _ready() -> void:
	_populate_factions()
	current_player_selected_index = 0
	current_battle_state = Library.BattleState.NONE

func _process(_delta: float) -> void:
	_populate_factions()
	if current_battle_state == Library.BattleState.NONE:
		_start_phase()
	if current_battle_state == Library.BattleState.ACTION_SELECTION:
		emit_signal("signal_action_select")
	if current_battle_state == Library.BattleState.ATTACK:
		emit_signal("signal_action_attack")
	if current_player_selected_index == players.size():
		_start_queue()

# Process Main Phases
func _select_action():
	action_buttons.get_children()[selected_action_index].grab_focus()
	if Input.is_action_just_pressed("ui_up"):
		selected_action_index = wrapi(selected_action_index - 1, 0, action_buttons.get_children().size())
		action_buttons.get_children()[selected_action_index].grab_focus()
	if Input.is_action_just_pressed("ui_down"):
		selected_action_index = wrapi(selected_action_index + 1, 0, action_buttons.get_children().size())
		action_buttons.get_children()[selected_action_index].grab_focus()
	if current_battle_state != Library.BattleState.ACTION_SELECTION:
		return
		
func _attack_main_loop():
	_hide_action_buttons()
	enemies[selected_enemy_index].focus()
	emit_signal("signal_enemy_select")
	
# Button Logic Emits
func _on_attack_pressed() -> void:
	current_battle_state = Library.BattleState.ATTACK

func _on_magic_pressed() -> void:
	current_battle_state = Library.BattleState.MAGIC

func _on_defend_pressed() -> void:
	current_battle_state = Library.BattleState.DEFEND

func _on_items_pressed() -> void:
	current_battle_state = Library.BattleState.ITEMS

func _on_run_pressed() -> void:
	current_battle_state = Library.BattleState.RUN

# UI LOGIC
func _reset_menu():
	action_buttons.show()

func _hide_action_buttons():
	action_buttons.hide()

func _select_enemy():
	var prec_selected_index
	if Input.is_action_just_pressed("ui_up"):
		prec_selected_index = selected_enemy_index
		selected_enemy_index = wrapi(selected_enemy_index - 1, 0, enemies.size())
		enemies[selected_enemy_index].focus()
		enemies[prec_selected_index].unfocus()
	if Input.is_action_just_pressed("ui_down"):
		prec_selected_index = selected_enemy_index
		selected_enemy_index = wrapi(selected_enemy_index + 1, 0, enemies.size())
		enemies[selected_enemy_index].focus()
		enemies[prec_selected_index].unfocus()
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("signal_target_selected")
		
# In game check and logic
func _start_queue():
	print(action_queue)
	for action in action_queue:
		# Caso di attacco semplice
		if action['action'] == null:
			action['target'].health -= clamp( action['origin'].attack - action['target'].defense, .0, Library.MAX_DAMAGE_OUTPUT)
	action_queue.clear()
	current_player_selected_index = 0

func _populate_factions():
	enemies = enemy_group.enemies
	players = party_group.party
	
func _start_phase():
	current_battle_state = Library.BattleState.ACTION_SELECTION
	for player in players:
		player.unfocus()
	players[current_player_selected_index].focus()
	
func _next_phase():
	var action_element = {
		"origin": players[current_player_selected_index], 
		"target": enemies[selected_enemy_index], 
		"speed": players[current_player_selected_index].speed, 
		"action": null
	}
	action_queue.push_back(action_element)
	_reset_menu()
	current_battle_state = Library.BattleState.NONE
	if current_player_selected_index < players.size():
		current_player_selected_index += 1
	
