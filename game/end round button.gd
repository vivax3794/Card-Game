extends Button


export(Vector2) var player1_pos
export(Vector2) var player2_pos


var current_player = 1


func _on_end_round_button_pressed():
	current_player = 2 if current_player == 1 else 1 
	
	if current_player == 2:
		set_position(player2_pos)
	else:
		set_position(player1_pos)
