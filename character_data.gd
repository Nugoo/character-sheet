@tool
class_name CharacterData
extends Resource

@export var Str : Ability = Ability.new("Str", 8)
@export var Dex : Ability = Ability.new("Dex", 8)
@export var Con : Ability = Ability.new("Con", 8)
@export var Int : Ability = Ability.new("Int", 8)
@export var Wis : Ability = Ability.new("Wis", 8)
@export var Cha : Ability = Ability.new("Cha", 8)

func get_abilities() -> Array[Ability]:
	return [Str, Dex, Con, Int, Wis, Cha]
