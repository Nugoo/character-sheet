extends GutTest

const character_sheet_path : String = "res://character_sheet.tscn"
const temp_save_path : String = "user://temp.char"

func after_each() -> void:
	gut.file_delete(temp_save_path)

func test_default():
	var character_sheet : CharacterSheet = autofree(load(character_sheet_path).instantiate()) as CharacterSheet
	add_child(character_sheet)
	
	assert_eq(character_sheet.data.path, "")
	assert_eq(character_sheet.data.name, "")
	assert_eq(character_sheet.data.Str.value, 8)
	assert_eq(character_sheet.data.Dex.value, 8)
	assert_eq(character_sheet.data.Con.value, 8)
	assert_eq(character_sheet.data.Int.value, 8)
	assert_eq(character_sheet.data.Wis.value, 8)
	assert_eq(character_sheet.data.Cha.value, 8)
	assert_eq(character_sheet.data.proficiency, 2)
	assert_false(character_sheet.data.str_save.proficient)
	assert_false(character_sheet.data.dex_save.proficient)
	assert_false(character_sheet.data.con_save.proficient)
	assert_false(character_sheet.data.int_save.proficient)
	assert_false(character_sheet.data.wis_save.proficient)
	assert_false(character_sheet.data.cha_save.proficient)

func test_save_and_load():
	var character_sheet : CharacterSheet = autofree(load(character_sheet_path).instantiate()) as CharacterSheet
	add_child(character_sheet)
	
	character_sheet.data.name = "Test Char"
	character_sheet.data.Str.value = 10
	character_sheet.data.Dex.value = 12
	character_sheet.data.Con.value = 14
	character_sheet.data.Int.value = 16
	character_sheet.data.Wis.value = 18
	character_sheet.data.Cha.value = 20
	character_sheet.data.proficiency = 3
	character_sheet.data.str_save.proficient = true
	character_sheet.data.dex_save.proficient = true
	character_sheet.data.con_save.proficient = true
	character_sheet.data.int_save.proficient = true
	character_sheet.data.wis_save.proficient = true
	character_sheet.data.cha_save.proficient = true
	
	character_sheet.save(temp_save_path)
	
	character_sheet.data = CharacterData.new()
	character_sheet.open(temp_save_path)
	
	assert_eq(character_sheet.data.path, temp_save_path)
	assert_eq(character_sheet.data.name, "Test Char")
	assert_eq(character_sheet.data.Str.value, 10)
	assert_eq(character_sheet.data.Dex.value, 12)
	assert_eq(character_sheet.data.Con.value, 14)
	assert_eq(character_sheet.data.Int.value, 16)
	assert_eq(character_sheet.data.Wis.value, 18)
	assert_eq(character_sheet.data.Cha.value, 20)
	assert_eq(character_sheet.data.proficiency, 3)
	assert_true(character_sheet.data.str_save.proficient)
	assert_true(character_sheet.data.dex_save.proficient)
	assert_true(character_sheet.data.con_save.proficient)
	assert_true(character_sheet.data.int_save.proficient)
	assert_true(character_sheet.data.wis_save.proficient)
	assert_true(character_sheet.data.cha_save.proficient)
