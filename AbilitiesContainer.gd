extends GridContainer

@export var abilityScene : PackedScene

@onready var character = $"../../Character"

var abilityNames = ["Str", "Dex", "Con", "Int", "Wis", "Cha"]

# Called when the node enters the scene tree for the first time.
func _ready():
	addLabels()
	
	for abilityName in abilityNames:
		var abilityValue = character.get(abilityName)
		addAbility(abilityName, abilityValue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func refresh():
	for abilityName in abilityNames:
		var abilityValue = character.get(abilityName)
		refreshAbility(abilityName, abilityValue)

func refreshAbility(name : String, value : int):
	var modLabel = get_node("modLabel" + name)
	modLabel.text = name
	var modValue = floor(value / 2) - 5
	modLabel.text = "%+d" % modValue

func addLabels():
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
	
func addAbility(name : String, value : int):
	var nameLabel = Label.new()
	nameLabel.text = name
	add_child(nameLabel)
	
	var on_spinbox_value_changed = func _on_spinbox_value_changed(value : float):
		character.set(name, int(value))
		$/root/CharacterSheet.refresh()
	
	var valueSpinBox = SpinBox.new()
	valueSpinBox.rounded = true
	valueSpinBox.theme = theme
	valueSpinBox.max_value = 99
	valueSpinBox.value = value
	valueSpinBox.value_changed.connect(on_spinbox_value_changed)
	add_child(valueSpinBox)
	
	var modLabel = Label.new()
	modLabel.name = "modLabel" + name
	modLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(modLabel)
	
	refreshAbility(name, value)
