class_name Proficiency
extends Resource

var proficient : bool
var ability : Ability


func _init(_proficient : bool, _ability : Ability) -> void:
	proficient = _proficient
	ability = _ability


func get_bonus(proficiency_bonus : int) -> int:
	if not proficient:
		proficiency_bonus = 0
	
	return proficiency_bonus + ability.get_modifier()
