extends Node2D

var Deck = load("res://deck/deck.gd")


export(int) var player


export(NodePath) var DeckPath
export(NodePath) var FieldPath
export(NodePath) var GamePath

onready var deck: Deck = get_node(DeckPath)
onready var Field = get_node(FieldPath)
onready var Game = get_node(GamePath)

onready var cards_node = get_node("cards")

func cards():
	return cards_node.get_children()
	
func draw_card():
	var new_card = deck.pop_random_into(cards_node)
	new_card.visible = true
	new_card.connect("clicked", self, "_card_clicked")


func play_card(card):
	if card.is_supported(Field.crowd_ammount()):
		card.disconnect("clicked", self, "_card_clicked")
		cards_node.remove_child(card)
		Field.add_card(card)


func _card_clicked(card):
	if Game.current_player == player:
		play_card(card)


func _ready():
	# wait for deck to be loaded
	yield(deck, "ready")
	# draw 5 orginal cards
	for _i in range(5):
		draw_card()


func _physics_process(_delta):
	if Input.is_action_just_pressed("debug"):
		draw_card()


func _on_game_turn_switch():
	if Game.current_player == player:
		draw_card()
