class_name Ability
extends Resource

var name : String
var value : int


func _init(_name : String, _value : int):
	name = _name
	value = _value


func get_modifier() -> int:
	return floor(value / 2.0) - 5
