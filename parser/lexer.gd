class_name Lexer
extends Object

enum TokenType {
	# Single-character
	PLUS, MINUS, ASTERISK, LEFT_PAREN, RIGHT_PAREN,
	# Multi-character
	DIV_MINUS, DIV_PLUS,
	# Literals
	INTEGER, DICE,
	# Keywords
	STR, STR_SCORE, STR_SAVE, DEX, DEX_SCORE, DEX_SAVE, CON, CON_SCORE,
	CON_SAVE, INT, INT_SCORE, INT_SAVE, WIS, WIS_SCORE, WIS_SAVE, CHA,
	CHA_SCORE, CHA_SAVE, LEVEL, PROFICIENCY,
	# eof
	EOF,
}


static var _keywords : Dictionary[String, TokenType] = {
	"str": TokenType.STR,
	"strscore": TokenType.STR_SCORE,
	"strsave": TokenType.STR_SAVE,
	"dex": TokenType.DEX,
	"dexscore": TokenType.DEX_SCORE,
	"dexsave": TokenType.DEX_SAVE,
	"con": TokenType.CON,
	"conscore": TokenType.CON_SCORE,
	"consave": TokenType.CON_SAVE,
	"int": TokenType.INT,
	"intscore": TokenType.INT_SCORE,
	"intsave": TokenType.INT_SAVE,
	"wis": TokenType.WIS,
	"wisscore": TokenType.WIS_SCORE,
	"wissave": TokenType.WIS_SAVE,
	"cha": TokenType.CHA,
	"chascore": TokenType.CHA_SCORE,
	"chasave": TokenType.CHA_SAVE,
	"level": TokenType.LEVEL,
	"prof": TokenType.PROFICIENCY,
}


var _source : PackedByteArray
var _tokens : Array[Token]
var _lex_start : int
var _lex_current : int
var _position : int
var _errors : Array[Error]


func _init(source : String):
	_source = source.to_utf8_buffer()
	_lex_start = 0
	_lex_current = 0


func scanTokens() -> Array[Token]:
	while !_eof():
		_lex_start = _lex_current
		_scan_token()
	
	_tokens.append(Token.new(TokenType.EOF, _lex_current, 0, "", null))
	return _tokens


func getErrors() -> Array[Error]:
	return _errors


func _eof() -> bool:
	return _lex_current >= _source.size()


func _scan_token() -> void:
	var c : String = _pop()
	match c:
		"+":
			_add_token(TokenType.PLUS)
		"-":
			_add_token(TokenType.MINUS)
		"*":
			_add_token(TokenType.ASTERISK)
		"(":
			_add_token(TokenType.LEFT_PAREN)
		")":
			_add_token(TokenType.RIGHT_PAREN)
		"/":
			var c2 : String = _pop()
			match c2:
				"+":
					_add_token(TokenType.DIV_PLUS)
				"-":
					_add_token(TokenType.DIV_MINUS)
				_:
					_add_error("unexpected character after '/'")
		" ", "\t", "\r", "\n":
			# Ignore whitespace
			pass
		_ when _is_digit(c):
			_scan_literal()
		_ when _is_alpha(c):
			_scan_identifier()
		_:
			_add_error("unexpected character")


func _pop() -> String:
	var c : String = String.chr(_source.get(_lex_current))
	_lex_current += 1
	return c


func _add_token(token_type : TokenType) -> void:
	_add_token_with_literal(token_type, null)


func _add_token_with_literal(token_type : TokenType, literal):
	var lexeme : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	_tokens.append(Token.new(token_type, _lex_start, lexeme.length(), lexeme, literal))


func _add_error(details : String) -> void:
	var lexeme : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	_errors.append(Error.new(_lex_start, lexeme.length(), details))


func _is_digit(c : String) -> bool:
	return c >= "0" && c <= "9"


func _scan_literal() -> void:
	_scan_integer()
	if _peek() == "d":
		if _is_digit(_peek2()):
			_pop()
			_scan_integer()
			var dice_literal : Dice = _parse_dice()
			_add_token_with_literal(TokenType.DICE, dice_literal)
			return
	var int_literal : int = _parse_integer()
	_add_token_with_literal(TokenType.INTEGER, int_literal)


func _scan_integer() -> void:
	while _is_digit(_peek()):
		_pop()


func _peek() -> String:
	if _eof():
		return ""
	return String.chr(_source.get(_lex_current))


func _peek2() -> String:
	if _lex_current + 1 >= _source.size():
		return ""
	return String.chr(_source.get(_lex_current + 1))


func _parse_dice() -> Dice:
	var lexeme : PackedByteArray = _source.slice(_lex_start, _lex_current)
	var string : String = lexeme.get_string_from_utf8()
	var ints : PackedStringArray = string.split("d")
	var count : int = ints[0].to_int()
	var die_type : int = ints[1].to_int()
	return Dice.new(die_type, count)


func _parse_integer() -> int:
	var substr : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	return substr.to_int()


func _is_alpha(c : String):
	return ((c >= "a" && c <= "z") ||
		(c >= "A" && c <= "Z") ||
		c == "_")


func _scan_identifier() -> void:
	while _is_alpha(_peek()):
		_pop()
	_parse_identifier()


func _parse_identifier() -> void:
	var lexeme : PackedByteArray = _source.slice(_lex_start, _lex_current)
	var name : String = lexeme.get_string_from_utf8().to_lower()
	if name in _keywords:
		_add_token(_keywords[name])
	else:
		_add_error("invalid identifier")


class Token:
	var _token_type : TokenType
	var _location : int
	var _length : int
	var _lexeme : String
	var _literal
	
	
	func _init(token_type : TokenType, location : int, length : int, lexeme : String, literal):
		_token_type = token_type
		_location = location
		_length = length
		_lexeme = lexeme
		_literal = literal


	func _to_string() -> String:
		return "Type: %s, location: %d, length: %d, lexeme: \"%s\", literal: %s" % [
			TokenType.keys()[_token_type], _location, _length, _lexeme, _literal
		]


class Dice:
	var _die_type : int
	var _die_count : int
	
	
	func _init(die_type : int, die_count : int):
		_die_type = die_type
		_die_count = die_count
