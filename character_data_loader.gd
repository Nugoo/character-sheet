class_name CharacterDataLoader
extends ResourceFormatLoader


func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["char"])


func _get_resource_script_class(_path : String) -> String:
	return "CharacterData"


func _get_resource_type(_path : String) -> String:
	return "Resource"


func _handles_type(type: StringName) -> bool:
	return ClassDB.is_parent_class(type, "Resource")


func _load(path : String, _original_path : String, _use_sub_threads : bool, _cache_mode : int) -> Variant:
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var character_data : CharacterData = CharacterData.new()
	
	var toc : PackedStringArray = file.get_csv_line()
	for i : int in toc.size() / 2:
		var section_name : String = toc[i*2]
		var section_size : int = int(toc[i*2 + 1])
		var section_buf : PackedByteArray = file.get_buffer(section_size)
		
		match section_name:
			"name":
				load_name(section_buf, character_data)
			"abilities":
				load_abilities(section_buf, character_data)
			"proficiency":
				load_proficiency(section_buf, character_data)
			"saves":
				load_saves(section_buf, character_data)
	
	return character_data


func load_name(buf : PackedByteArray, character_data : CharacterData) -> void:
	character_data.name = buf.get_string_from_utf8()


func load_proficiency(buf : PackedByteArray, character_data : CharacterData) -> void:
	character_data.proficiency = buf.decode_u8(0)


func load_abilities(buf : PackedByteArray, character_data : CharacterData) -> void:
	var ability_index : int = 0
	for ability : Ability in character_data.get_abilities():
		ability.value = buf.decode_u8(ability_index)
		ability_index += 1


func load_saves(buf : PackedByteArray, character_data : CharacterData) -> void:
	var save_index : int = 0
	for save : Proficiency in character_data.get_saves():
		save.proficient = buf.decode_u8(save_index)
		save_index += 1
