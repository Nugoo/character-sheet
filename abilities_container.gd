extends GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("character_view")
	add_labels()

	for ability in get_character_data().get_abilities():
		add_ability(ability)

func get_character_data() -> CharacterData:
	return $"/root/CharacterSheet".data

func refresh() -> void:
	for ability in get_character_data().get_abilities():
		refresh_ability(ability)

func refresh_ability(ability : Ability) -> void:
	var valueSpinBox = get_node("valueSpinBox" + ability.name)
	valueSpinBox.set_value_no_signal(ability.value)
	
	var modLabel = get_node("modLabel" + ability.name)
	modLabel.text = ability.name
	var modValue = floor(ability.value / 2) - 5
	modLabel.text = "%+d" % modValue

func add_labels() -> void:
	var abilityLabel = Label.new()
	abilityLabel.text = "Ability"
	abilityLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(abilityLabel)
	
	var valueLabel = Label.new()
	valueLabel.text = "Value"
	valueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(valueLabel)
	
	var modLabel = Label.new()
	modLabel.text = "Mod"
	modLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(modLabel)
	
func add_ability(ability : Ability) -> void:
	var nameLabel = Label.new()
	nameLabel.text = ability.name
	add_child(nameLabel)
	
	var on_spinbox_value_changed = func _on_spinbox_value_changed(value : float):
		get_character_data().get(ability.name).value = value
		$/root/CharacterSheet.refresh()
	
	var valueSpinBox = SpinBox.new()
	valueSpinBox.name = "valueSpinBox" + ability.name
	valueSpinBox.rounded = true
	valueSpinBox.theme = theme
	valueSpinBox.max_value = 99
	valueSpinBox.value_changed.connect(on_spinbox_value_changed)
	add_child(valueSpinBox)
	
	var modLabel = Label.new()
	modLabel.name = "modLabel" + ability.name
	modLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(modLabel)
	
	refresh_ability(ability)
