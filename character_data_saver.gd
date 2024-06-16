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
	
	var ability_buf : PackedByteArray = save_abilities(character_data)
	var ability_size : int = len(ability_buf)
	
	# Save file is prefixed with a csv line, of the format:
	# "<section-1-name>,<section-1-size>,<section-2-name>,<section-2-size>,..."
	var toc : PackedStringArray = PackedStringArray()
	toc.push_back("abilities")
	toc.push_back(str(ability_size))
	
	# Save to file
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_csv_line(toc)
	file.store_buffer(ability_buf)

func save_abilities(character_data : CharacterData) -> PackedByteArray:
	var ability_buf : PackedByteArray = PackedByteArray()
	var abilities : Array[Ability] = character_data.get_abilities()
	ability_buf.resize(abilities.size())
	
	var ability_index : int = 0
	for ability in abilities:
		ability_buf.encode_u8(ability_index, ability.value)
		ability_index += 1
	
	return ability_buf
