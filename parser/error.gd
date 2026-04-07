class_name Error
extends Object

var location : int
var length : int
var details : String

func _init(p_location : int, p_length : int, p_details : String) -> void:
	self.location = p_location
	self.length = p_length
	self.details = p_details


func _to_string() -> String:
	return "location: %d, length: %d, details: %s" % [location, length, details]
