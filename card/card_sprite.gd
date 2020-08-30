tool

extends Node2D

export(String) var card_title
export(int) var range_start
export(int) var range_end
export(int) var attack
export(int) var health
export(String, MULTILINE) var effect_text
export(String) var description
export(Color) var background

export(NodePath) var CardNodePath
onready var CardNode: KinematicBody2D = get_node(CardNodePath)
onready var animation = get_node("AnimationPlayer")


func _ready():
	update_nodes()

func parse_effect() -> String:
	return effect_text.replace("<", "[color=yellow]").replace(">", "[/color]")


func update_nodes():
	get_node("background").color = background
	get_node("title").text = "%s (%s-%s)" % [card_title, range_start, range_end]
	get_node("attack/value").text = str(attack)
	get_node("health/value").text = str(health)
	get_node("description").text = description
	get_node("card text").bbcode_text = parse_effect()


func _on_card_mouse_entered():
	# ignore if card is dead
	if health > 0:
		animation.play("zoom in")


func _on_card_mouse_exited():
	# ignore if card is dead
	if health > 0:
		animation.play_backwards("zoom in")
