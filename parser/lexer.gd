class_name Lexer
extends Object

enum TokenType {
	# Single-character
	PLUS, MINUS, ASTERISK, LEFT_PAREN, RIGHT_PAREN,
	# Multi-character
	DIV_MINUS, DIV_PLUS,
	# Literals
	INTEGER,
	# Die
	DIE,
	# Keywords
	STR, STR_SCORE, DEX, DEX_SCORE, CON, CON_SCORE, INT, INT_SCORE, WIS,
	WIS_SCORE, CHA, CHA_SCORE, LEVEL, PROFICIENCY,
	# eof
	EOF,
}


static var _keywords : Dictionary[String, TokenType] = {
	"str": TokenType.STR,
	"strscore": TokenType.STR_SCORE,
	"dex": TokenType.DEX,
	"dexscore": TokenType.DEX_SCORE,
	"con": TokenType.CON,
	"conscore": TokenType.CON_SCORE,
	"int": TokenType.INT,
	"intscore": TokenType.INT_SCORE,
	"wis": TokenType.WIS,
	"wisscore": TokenType.WIS_SCORE,
	"cha": TokenType.CHA,
	"chascore": TokenType.CHA_SCORE,
	"level": TokenType.LEVEL,
	"prof": TokenType.PROFICIENCY,
}


var _source : PackedByteArray
var _tokens : Array[Token]
var _lex_start : int
var _lex_current : int
var _errors : Array[Err]


func _init(source : String) -> void:
	_source = source.to_utf8_buffer()
	_lex_start = 0
	_lex_current = 0


func scanTokens() -> Array[Token]:
	while !_eof():
		_lex_start = _lex_current
		_scan_token()
	
	_tokens.append(Token.new(TokenType.EOF, _lex_current, 0, "", null))
	return _tokens


func getErrors() -> Array[Err]:
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
					_add_error("unexpected character after '/': '%s', expected '+' or '-'" % c2)
		" ", "\t", "\r", "\n":
			# Ignore whitespace
			pass
		_ when _is_digit(c):
			_scan_integer()
			var int_literal : int = _parse_integer()
			_add_token_with_literal(TokenType.INTEGER, int_literal)
		_ when _is_alpha(c):
			if c == "d" && _is_digit(_peek()):
				_scan_integer()
				var die_literal : Die = _parse_die()
				_add_token_with_literal(TokenType.DIE, die_literal)
			else:
				_scan_identifier()
		_:
			_add_error("unexpected character: '%s'" % c)


func _pop() -> String:
	var c : String = String.chr(_source.get(_lex_current))
	_lex_current += 1
	return c


func _add_token(token_type : TokenType) -> void:
	_add_token_with_literal(token_type, null)


func _add_token_with_literal(token_type : TokenType, literal) -> void:
	var lexeme : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	_tokens.append(Token.new(token_type, _lex_start, lexeme.length(), lexeme, literal))


func _add_error(details : String) -> void:
	var lexeme : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	_errors.append(Err.new(_lex_start, lexeme.length(), details))


func _is_digit(c : String) -> bool:
	return c >= "0" && c <= "9"


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


func _parse_die() -> Die:
	var lexeme : PackedByteArray = _source.slice(_lex_start, _lex_current)
	var string : String = lexeme.get_string_from_utf8()
	var sides_str : String = string.trim_prefix("d")
	var sides : int = sides_str.to_int()
	return Die.new(sides)


func _parse_integer() -> int:
	var substr : String = _source.slice(_lex_start, _lex_current).get_string_from_utf8()
	return substr.to_int()


func _is_alpha(c : String) -> bool:
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
		_add_error("invalid identifier: \"%s\"" % name)


class Token:
	var _token_type : TokenType
	var _location : int
	var _length : int
	var _lexeme : String
	var _literal
	
	
	func _init(p_token_type : TokenType, p_location : int, p_length : int, p_lexeme : String, p_literal) -> void:
		_token_type = p_token_type
		_location = p_location
		_length = p_length
		_lexeme = p_lexeme
		_literal = p_literal
	
	
	func _to_string() -> String:
		return "Type: %s, location: %d, length: %d, lexeme: \"%s\", literal: %s" % [
			TokenType.keys()[_token_type], _location, _length, _lexeme, _literal
		]
	
	
	func type() -> TokenType:
		return _token_type
	
	
	func literal():
		return _literal


class Die:
	var _sides : int
	
	
	func _init(sides : int) -> void:
		_sides = sides


class Err:
	var location : int
	var length : int
	var details : String

	func _init(p_location : int, p_length : int, p_details : String) -> void:
		self.location = p_location
		self.length = p_length
		self.details = p_details


	func _to_string() -> String:
		return "location: %d, length: %d, details: %s" % [location, length, details]
