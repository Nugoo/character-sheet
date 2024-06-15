extends PopupMenu


func _on_index_pressed(index : int) -> void:
	var itemText = get_item_text(index)
	
	match itemText:
		"Open...":
			$/root/CharacterSheet.file_open()
		"Save":
			#$/root/CharacterSheet.fileSave()
			pass
		"Save As...":
			$/root/CharacterSheet.file_save_as()
