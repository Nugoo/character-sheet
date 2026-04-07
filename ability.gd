class_name Ability
extends Resource

var name : String
var value : int


func _init(_name : String, _value : int) -> void:
	name = _name
	value = _value


func get_modifier() -> int:
	return floor(value / 2.0) - 5
