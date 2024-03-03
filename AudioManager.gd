extends Node
@onready var victory_sound: AudioStreamPlayer = $VictorySound
@onready var choice_sound: AudioStreamPlayer = $ChoiceSound
@onready var confirm_sound: AudioStreamPlayer = $ConfirmSound


func _on_battle_scene_signal_battle_ended() -> void:
	if !victory_sound.playing:
		victory_sound.play()


func _on_battle_scene_signal_move_selection_cursor() -> void:
	choice_sound.play()


func _on_battle_scene_signal_confirm_selection_cursor() -> void:
	confirm_sound.play()
