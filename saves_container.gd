extends GridContainer


func _ready() -> void:
	add_to_group("character_view")
	add_labels()

	var character_data : CharacterData = get_character_data()
	for save in character_data.get_saves():
		add_save(save, character_data)


func get_character_data() -> CharacterData:
	return owner.data


func refresh() -> void:
	var character_data : CharacterData = get_character_data()
	for save in character_data.get_saves():
		refresh_save(save, character_data)


func refresh_save(save : Proficiency, character_data : CharacterData) -> void:
	var proficient_checkbutton = get_node("proficient_checkbutton" + save.ability.name)
	proficient_checkbutton.set_pressed_no_signal(save.proficient)
	
	var bonus_label = get_node("bonus_label" + save.ability.name)
	bonus_label.text = "%+d" % save.get_bonus(character_data.proficiency)


func add_labels() -> void:
	var abilityLabel = Label.new()
	abilityLabel.text = "Save"
	abilityLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(abilityLabel)
	
	var valueLabel = Label.new()
	valueLabel.text = "Proficient"
	valueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(valueLabel)
	
	var bonus_label = Label.new()
	bonus_label.text = "Bonus"
	bonus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(bonus_label)


func add_save(save : Proficiency, character_data : CharacterData) -> void:
	var nameLabel = Label.new()
	nameLabel.text = save.ability.name
	add_child(nameLabel)
	
	var on_checkbutton_toggled = func _on_checkbutton_toggled(toggled_on : bool) -> void:
		get_character_data().get(save.ability.name.to_lower() + "_save").proficient = toggled_on
		owner.refresh()
	
	var proficient_checkbutton : CheckButton = CheckButton.new()
	proficient_checkbutton.name = "proficient_checkbutton" + save.ability.name
	proficient_checkbutton.toggled.connect(on_checkbutton_toggled)
	add_child(proficient_checkbutton)
	
	var bonus_label = Label.new()
	bonus_label.name = "bonus_label" + save.ability.name
	bonus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(bonus_label)
	
	refresh_save(save, character_data)
