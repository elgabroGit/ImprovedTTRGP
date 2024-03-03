extends CanvasLayer
@onready var action_buttons: VBoxContainer = $ActionButtons
@onready var panel_victory: Panel = $PanelVictory
@onready var victory_button: Button = $PanelVictory/VictoryButton

func _on_battle_scene_signal_start_ui() -> void:
	action_buttons.visible = true

func _on_battle_scene_signal_stop_ui() -> void:
	action_buttons.visible = false

func _on_battle_scene_signal_battle_ended() -> void:
	panel_victory.visible = true
	victory_button.grab_focus()



func _on_victory_button_pressed() -> void:
	get_tree().quit()
