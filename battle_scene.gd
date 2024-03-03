extends Node2D

@onready var action_buttons: VBoxContainer = $UI/ActionButtons
@onready var enemy_group: Node2D = $EnemyGroup
@onready var party_group: Node2D = $PartyGroup
@onready var log_box_text: Label = $UI/PanelLogBox/LogBoxText

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
signal signal_confirm_selection_cursor
signal signal_target_selected
signal signal_stop_ui
signal signal_start_ui
signal signal_battle_ended

func _ready() -> void:
	_populate_factions()
	current_player_selected_index = 0
	current_battle_state = Library.BattleState.NONE

func _process(_delta: float) -> void:
	if _check_battle_status(): 
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
		emit_signal("signal_move_selection_cursor")
		selected_action_index = wrapi(selected_action_index - 1, 0, action_buttons.get_children().size())
		action_buttons.get_children()[selected_action_index].grab_focus()
	if Input.is_action_just_pressed("ui_down"):
		emit_signal("signal_move_selection_cursor")
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
	emit_signal("signal_confirm_selection_cursor")
	current_battle_state = Library.BattleState.ATTACK

func _on_magic_pressed() -> void:
	emit_signal("signal_confirm_selection_cursor")
	current_battle_state = Library.BattleState.MAGIC

func _on_defend_pressed() -> void:
	emit_signal("signal_confirm_selection_cursor")
	current_battle_state = Library.BattleState.DEFEND

func _on_items_pressed() -> void:
	emit_signal("signal_confirm_selection_cursor")
	current_battle_state = Library.BattleState.ITEMS

func _on_run_pressed() -> void:
	emit_signal("signal_confirm_selection_cursor")
	current_battle_state = Library.BattleState.RUN

# UI LOGIC
func _clear_enemy_focuses():
	for enemy in enemies:
		enemy.unfocus()

func _clean_log_box():
	log_box_text.text = ''

func _reset_menu():
	action_buttons.show()

func _hide_action_buttons():
	action_buttons.hide()

func _select_enemy():
	var prec_selected_index
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("signal_move_selection_cursor")
		prec_selected_index = selected_enemy_index
		selected_enemy_index = wrapi(selected_enemy_index - 1, 0, enemies.size())
		enemies[selected_enemy_index].focus()
		enemies[prec_selected_index].unfocus()
	if Input.is_action_just_pressed("ui_down"):
		emit_signal("signal_move_selection_cursor")
		prec_selected_index = selected_enemy_index
		selected_enemy_index = wrapi(selected_enemy_index + 1, 0, enemies.size())
		enemies[selected_enemy_index].focus()
		enemies[prec_selected_index].unfocus()
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("signal_confirm_selection_cursor")
		emit_signal("signal_target_selected")
		
# In game check and logic
func _start_queue():
	_clear_enemy_focuses()
	current_player_selected_index = 0
	selected_enemy_index = 0
	_clean_log_box()
	emit_signal("signal_stop_ui")
	for action in action_queue:
		_populate_factions()
		# Caso di attacco semplice
		if action['action'] == null:
			if !_validate_origins_and_targets(action):
				continue
			action['origin'].attack_animation()
			log_box_text.text +=  str( action['origin'].character_name ) + ' attacca ' + str( action['target'].character_name ) + '\n'
			action['target'].health -= clamp( action['origin'].attack - action['target'].defense, .0, Library.MAX_DAMAGE_OUTPUT)
			await get_tree().create_timer(1.2).timeout
	action_queue.clear()
	emit_signal("signal_start_ui")

func _validate_origins_and_targets(action) -> bool:
	if !is_instance_valid(action['origin']):
		return false
	if !is_instance_valid(action['target']):
		if action['origin'].is_enemy:
			action['target'] = players[0]
		else:
			action['target'] = enemies[0]
	return true

func _populate_factions():
	enemies = enemy_group.enemies
	players = party_group.players
	
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

func _check_battle_status() -> bool:
	if enemies.size() == 0:
		emit_signal("signal_battle_ended")
		return false
	return true	
	
# Enemy AI
func _generate_random_attack():
	pass
