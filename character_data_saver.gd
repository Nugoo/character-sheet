class_name CharacterDataSaver
extends ResourceFormatSaver


func _get_recognized_extensions(resource : Resource) -> PackedStringArray:
	return PackedStringArray(["char"])


func _recognize(resource : Resource) -> bool:
	return resource is CharacterData


func _save(resource : Resource, path : String, flags : int):
	if not(resource is CharacterData):
		return ERR_INVALID_DATA
	
	var character_data : CharacterData = resource as CharacterData
	
	var name_buf : PackedByteArray = character_data.name.to_utf8_buffer()
	var name_size : int = name_buf.size()
	var proficiency_buf : PackedByteArray = save_proficiency(character_data)
	var proficiency_size : int = proficiency_buf.size()
	var ability_buf : PackedByteArray = save_abilities(character_data)
	var ability_size : int = ability_buf.size()
	var save_buf : PackedByteArray = save_saves(character_data)
	var save_size : int = save_buf.size()
	
	# Save file is prefixed with a csv line, of the format:
	# "<section-1-name>,<section-1-size>,<section-2-name>,<section-2-size>,..."
	var toc : PackedStringArray = PackedStringArray()
	toc.push_back("name")
	toc.push_back(str(name_size))
	toc.push_back("proficiency")
	toc.push_back(str(proficiency_size))
	toc.push_back("abilities")
	toc.push_back(str(ability_size))
	toc.push_back("saves")
	toc.push_back(str(save_size))
	
	# Save to file
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_csv_line(toc)
	file.store_buffer(name_buf)
	file.store_buffer(proficiency_buf)
	file.store_buffer(ability_buf)
	file.store_buffer(save_buf)


func save_proficiency(character_data : CharacterData) -> PackedByteArray:
	var save_buf : PackedByteArray = PackedByteArray()
	save_buf.resize(1)
	save_buf.encode_u8(0, character_data.proficiency)
	return save_buf


func save_abilities(character_data : CharacterData) -> PackedByteArray:
	var ability_buf : PackedByteArray = PackedByteArray()
	var abilities : Array[Ability] = character_data.get_abilities()
	ability_buf.resize(abilities.size())
	
	var ability_index : int = 0
	for ability in abilities:
		ability_buf.encode_u8(ability_index, ability.value)
		ability_index += 1
	
	return ability_buf


func save_saves(character_data : CharacterData) -> PackedByteArray:
	var save_buf : PackedByteArray = PackedByteArray()
	var saves : Array[Proficiency] = character_data.get_saves()
	save_buf.resize(saves.size())
	
	var save_index : int = 0
	for save in saves:
		save_buf.encode_u8(save_index, save.proficient)
		save_index += 1
	
	return save_buf
