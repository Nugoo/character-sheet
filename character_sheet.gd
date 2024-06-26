class_name CharacterSheet
extends Control

@export var data : CharacterData = CharacterData.new()


func _on_open_file_dialog_file_selected(path : String) -> void:
	open(path)


func _on_save_file_dialog_file_selected(path : String) -> void:
	save(path)


func file_open() -> void:
	$OpenFileDialog.popup()


func file_save_as() -> void:
	if data.path != "":
		$SaveFileDialog.current_path = data.path
	else:
		$SaveFileDialog.current_path = data.name.to_lower().validate_filename() + ".char"
	
	$SaveFileDialog.popup()


func open(path : String) -> void:
	print("Opening ", path)
	data = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	data.path = path
	refresh()


func save(path : String) -> void:
	if path.get_extension() != "char":
		path += ".char"
	
	data.path = path
	print("Saving to ", path)
	var err = ResourceSaver.save(data, path)
	if err != OK:
		printerr("Failed to save: ", error_string(err))


func _draw() -> void:
	print("Drawing root")


func refresh() -> void:
	if data.name != "":
		get_window().title = data.name
	
	get_tree().call_group("character_view", "refresh")
