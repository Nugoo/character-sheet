extends VBoxContainer


func _ready():
	add_to_group("character_view")
	refresh()


func get_character_data() -> CharacterData:
	return owner.data


func refresh() -> void:
	$ProficiencySpinBox.set_value_no_signal(get_character_data().proficiency)


func _on_proficiency_spin_box_value_changed(value : float) -> void:
	get_character_data().proficiency = int(value)
	owner.refresh()
