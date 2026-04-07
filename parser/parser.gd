class_name Parser
extends Object


var _character : CharacterData
var _tokens : Array[Lexer.Token]
var _current : int


func _init(character : CharacterData, tokens : Array[Lexer.Token]) -> void:
	_character = character
	_tokens = tokens


func parse_expression() -> ParseResult:
	return _parse_term()


func _parse_term() -> ParseResult:
	var res : ParseResult = _parse_factor()
	if res.err != null:
		return res
	var expr : Expr = res.expr
	
	while _peek().type() in [Lexer.TokenType.PLUS, Lexer.TokenType.MINUS]:
		var token : Lexer.Token = _pop()
		res = _parse_factor()
		if res.err != null:
			return res
		var right : Expr = res.expr
		expr = Expr.Binary.new(expr, right, token)
	
	return _make_result(expr)


func _parse_factor() -> ParseResult:
	var res : ParseResult = _parse_unary()
	if res.err != null:
		return res
	var expr : Expr = res.expr
	
	while _peek().type() in [
		Lexer.TokenType.ASTERISK, Lexer.TokenType.DIV_PLUS, Lexer.TokenType.DIV_MINUS,
	]:
		var token : Lexer.Token = _pop()
		res = _parse_unary()
		if res.err != null:
			return res
		var right : Expr = res.expr
		expr = Expr.Binary.new(expr, right, token)
	
	return _make_result(expr)


func _parse_unary() -> ParseResult:
	if _peek().type() in [Lexer.TokenType.MINUS]:
		var token : Lexer.Token = _pop()
		var unary_res : ParseResult = _parse_unary()
		if unary_res.err != null:
			return unary_res
		var right : Expr = unary_res.expr
		return _make_result(Expr.Unary.new(right, token))
	
	var res : ParseResult = _parse_primary()
	if res.err != null:
		return res
	var expr : Expr = res.expr
	
	if _peek().type() == Lexer.TokenType.DIE:
		expr = Expr.Die.new(expr, _pop().literal())
	
	return _make_result(expr)


func _parse_primary() -> ParseResult:
	match _peek().type():
		Lexer.TokenType.INTEGER:
			return _make_result(Expr.Literal.new(_pop().literal()))
		Lexer.TokenType.LEFT_PAREN:
			_pop()
			var res : ParseResult = parse_expression()
			if res.err != null:
				return res
			var expr : Expr = res.expr
			if _peek().type() == Lexer.TokenType.RIGHT_PAREN:
				_pop()
				return _make_result(Expr.Grouping.new(expr))
			else:
				return _make_error(Err.new(_peek(), "expect ')' after expression"))
		Lexer.TokenType.STR, Lexer.TokenType.STR_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.DEX, Lexer.TokenType.DEX_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.CON, Lexer.TokenType.CON_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.INT, Lexer.TokenType.INT_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.WIS, Lexer.TokenType.WIS_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.CHA, Lexer.TokenType.CHA_SCORE:
			return _make_result(Expr.Field.new(_character, _pop()))
		Lexer.TokenType.LEVEL, Lexer.TokenType.PROFICIENCY:
			return _make_result(Expr.Field.new(_character, _pop()))
		_:
			return _make_error(Err.new(_peek(), "unexpected primary expression"))


func _peek() -> Lexer.Token:
	return _tokens.get(_current)


func _pop() -> Lexer.Token:
	var token : Lexer.Token = _tokens.get(_current)
	if !_eof():
		_current += 1
	return token


func _eof() -> bool:
	return _peek().type() == Lexer.TokenType.EOF


func _make_result(expr : Expr) -> ParseResult:
	var res : ParseResult = ParseResult.new()
	res.expr = expr
	return res


func _make_error(err : Err) -> ParseResult:
	var res : ParseResult = ParseResult.new()
	res.err = err
	return res


class Err:
	var token : Lexer.Token
	var details : String
	
	
	func _init(p_token : Lexer.Token, p_details : String) -> void:
		token = p_token
		details = p_details
	
	
	func _to_string() -> String:
		return "Token: %s, details: %s" % [token, details]


class ParseResult:
	var expr : Expr
	var err : Err
