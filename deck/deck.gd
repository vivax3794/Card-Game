class_name Deck

extends Node2D

var Card = load("res://card/card.gd")

var rng = RandomNumberGenerator.new()

onready var cards_node = get_node("cards")


func cards() -> Array:
	return cards_node.get_children()
	

func _ready():
	rng.randomize()
	print("seed: %s" % rng.seed)
	for card in cards():
		card.visible = false
	
	# add 10 extra copies of each card
	for card in cards():
		for _i in range(5):
			# print("duplicated %s" % card.card_title)
			cards_node.add_child(card.duplicate())


func add_card(card):
	cards_node.add_child(card)
	card.visible = false
	card.reset()


func remove(index: int):
	var card = cards()[index]
	cards_node.remove_child(card)


func pop_random_into(target: Node) -> Card:
	var lenght = cards().size()
	var index = rng.randi_range(0, lenght - 1)
	var card = cards()[index]
	
	cards_node.remove_child(card)
	target.add_child(card)
	return card
