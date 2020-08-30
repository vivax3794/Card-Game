class_name Field

extends Node2D


var Card = load("res://card/card.gd")


export(int) var player

export(NodePath) var HandPath
export(NodePath) var EnemyFieldPath
export(NodePath) var GamePath
export(NodePath) var DeckPath

onready var Hand = get_node(HandPath)
onready var EnemyField = get_node(EnemyFieldPath)
onready var Game = get_node(GamePath)
onready var Deck = get_node(DeckPath)

onready var cards_node = get_node("cards")


var selected_card = null


func add_card(card):
	card.asleep = true
	cards_node.add_child(card)
	card.connect("clicked", self, "_card_clicked")


func select_card(card):
	selected_card = card
	card.selected = true
	card.update_sprite()


func unselect_card(card):
	selected_card = null
	card.selected = false
	card.update_sprite()


func _card_clicked(card):
	if Game.current_player == player:
		if (not card.asleep) and (not card.heavy):
			if selected_card != null: unselect_card(selected_card)
			select_card(card)
	else:
		if EnemyField.selected_card != null:
			var attacker = EnemyField.selected_card
			var target = card
			EnemyField.unselect_card(EnemyField.selected_card)
			
			attack_card(attacker, target)

func crowd_ammount() -> int:
	var crowd = 0
	for card in cards_node.get_children():
		crowd += 1
		crowd += card.extra_crowding_self(self)
	
	for card in EnemyField.cards_node.get_children():
		crowd += card.extra_crowding_enemy(self)
		
	# print("current crowd: %s" % crowd)
	return crowd


func kill_card(card):
	card.asleep = false
	card.animation.play("Killed")
	yield(card.animation, "animation_finished")
	card.animation.play_backwards("Killed")
	cards_node.remove_child(card)
	card.disconnect("clicked", self, "_card_clicked")
	Deck.add_card(card)


func attack_card(attacker: Card, target: Card):
	attacker.asleep = true
	
	var attacker_dead
	if attacker.swift:
		attacker_dead = false
	else:
		attacker_dead = attacker.take_dmg(target.dmg)
	var target_dead =  target.take_dmg(attacker.dmg)
	
	if attacker_dead:
		EnemyField.kill_card(attacker)
	if target_dead:
		self.kill_card(target)


func _on_game_turn_switch():
	if selected_card != null:
		unselect_card(selected_card)
	for card in cards_node.get_children():
		card.asleep = false
		if (
			(not card.is_supported(crowd_ammount())) and
			(not card.brave)
		):
			kill_card(card)
