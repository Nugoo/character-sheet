@tool
class_name CharacterData
extends Resource

@export var name : String = ""

@export var Str : Ability = Ability.new("Str", 8)
@export var Dex : Ability = Ability.new("Dex", 8)
@export var Con : Ability = Ability.new("Con", 8)
@export var Int : Ability = Ability.new("Int", 8)
@export var Wis : Ability = Ability.new("Wis", 8)
@export var Cha : Ability = Ability.new("Cha", 8)

@export var proficiency : int = 2

@export var str_save : Proficiency = Proficiency.new(false, Str)
@export var dex_save : Proficiency = Proficiency.new(false, Dex)
@export var con_save : Proficiency = Proficiency.new(false, Con)
@export var int_save : Proficiency = Proficiency.new(false, Int)
@export var wis_save : Proficiency = Proficiency.new(false, Wis)
@export var cha_save : Proficiency = Proficiency.new(false, Cha)

var path : String = ""


func get_abilities() -> Array[Ability]:
	return [Str, Dex, Con, Int, Wis, Cha]


func get_saves() -> Array[Proficiency]:
	return [str_save, dex_save, con_save, int_save, wis_save, cha_save]
