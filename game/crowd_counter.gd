extends Node2D


export(NodePath) var FieldPath

onready var Filed = get_node(FieldPath)


func _process(_delta):
	get_node("Label").text = str(Filed.crowd_ammount())
