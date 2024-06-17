extends PanelContainer


func _ready() -> void:
	add_to_group("character_view")
	refresh()


func get_character_data() -> CharacterData:
	return $"/root/CharacterSheet".data


func refresh() -> void:
	$HBoxContainer/NameTextEdit.text = get_character_data().name


func _on_name_text_edit_text_submitted(new_text):
	get_character_data().name = new_text
	$/root/CharacterSheet.refresh()
