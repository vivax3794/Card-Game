extends Node2D

onready var player_1 = get_node("player-1")
onready var player_2 = get_node("player-2")


var current_player: int = 1


signal turn_switch


func switch_turn():
	current_player = 2 if current_player == 1 else 1
	emit_signal("turn_switch")


func _on_end_round_button_pressed():
	# TODO: make this check that the current turn is not the turn of a ai
	switch_turn()
