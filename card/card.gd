class_name Card

extends KinematicBody2D

export(int) var base_health
export(int) var base_dmg
export(String) var card_title
export(int) var range_start
export(int) var range_end
export(String, MULTILINE) var effect_text
export(String) var description
export(Color) var background = Color(0, 0, 0)
export(Color) var highligthed = Color("002a6d")
export(Color) var asleep_background

var selected = false


# effects
export(int) var EC = 0
export(int) var EEC = 0
export(bool) var brave = false
export(bool) var heavy = false
export(bool) var swift = false

onready var health = base_health
onready var dmg = base_dmg

onready var sprite = get_node("sprite")
onready var animation = get_node("sprite/AnimationPlayer")


var asleep = false


signal clicked(card)

func _ready():
	sprite.card_title = card_title
	sprite.range_start = range_start
	sprite.range_end = range_end
	sprite.effect_text = effect_text
	sprite.description = description
	update_sprite()


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		emit_signal("clicked", self)

func _process(_delta):
	update_sprite()


func reset():
	health = base_health
	dmg = base_dmg
	update_sprite()


func update_sprite():
	sprite.health = health
	sprite.attack = dmg
#	print("I am selected: %s" % selected)
	if selected:
		sprite.background = highligthed
	elif asleep:
		sprite.background = asleep_background
	else:
		sprite.background = background
	sprite.update_nodes()
	
	
func take_dmg(ammount: int) -> bool:
	health -= ammount
	update_sprite()
	return health <= 0
	
func is_supported(crowd: int) -> bool:
	return range_start <= crowd and crowd <= range_end


# "events"
func extra_crowding_self(_Filed) -> int:
	# should this add any extra crowding?
	return EC

func extra_crowding_enemy(_EnemyField) -> int:
	# should this add any extra crowding to the enemy?
	return EEC
