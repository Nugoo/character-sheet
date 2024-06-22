extends PopupMenu


func _on_index_pressed(index : int) -> void:
	var itemText = get_item_text(index)
	
	match itemText:
		"Open...":
			owner.file_open()
		"Save":
			#owner.fileSave()
			pass
		"Save As...":
			owner.file_save_as()
