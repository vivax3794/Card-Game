extends Node2D

export(int) var offset

var card_width = 350

func _process(_delta):
	var current_pos = 0
	for card in get_children():
		card.position.x = current_pos
		current_pos += card_width + offset
