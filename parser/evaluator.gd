class_name Evaluator
extends Expr.Visitor


var _rng : RandomNumberGenerator


func _init(p_seed : int) -> void:
	_rng = RandomNumberGenerator.new()
	if p_seed != 0:
		_rng.seed = p_seed
	else:
		_rng.randomize()


func visit_binary(e : Expr.Binary) -> EvalResult:
	var left_res : EvalResult = e.left.accept(self)
	if left_res.err != null:
		return left_res
	var right_res : EvalResult = e.right.accept(self)
	if right_res.err != null:
		return right_res
	
	match e.operator.type():
		Lexer.TokenType.PLUS:
			return EvalResult.from_value(left_res.value + right_res.value)
		Lexer.TokenType.MINUS:
			return EvalResult.from_value(left_res.value - right_res.value)
		Lexer.TokenType.ASTERISK:
			return EvalResult.from_value(left_res.value * right_res.value)
		Lexer.TokenType.DIV_PLUS:
			if right_res.value == 0:
				return EvalResult.from_err(Err.new(e.operator, "division by zero"))
			var value : float = float(left_res.value) / right_res.value
			return EvalResult.from_value(ceili(value))
		Lexer.TokenType.DIV_MINUS:
			if right_res.value == 0:
				return EvalResult.from_err(Err.new(e.operator, "division by zero"))
			var value : float = float(left_res.value) / right_res.value
			return EvalResult.from_value(floori(value))
		_:
			return EvalResult.from_err(Err.new(e.operator, "unexpected operator"))


func visit_unary(e : Expr.Unary) -> EvalResult:
	var res : EvalResult = e.right.accept(self)
	if res.err != null:
		return res
	
	match e.operator.type():
		Lexer.TokenType.MINUS:
			return EvalResult.from_value(-res.value)
		_:
			return EvalResult.from_err(Err.new(e.operator, "unexpected operator"))


func visit_grouping(e : Expr.Grouping) -> EvalResult:
	return e.expr.accept(self)


func visit_literal(e : Expr.Literal) -> EvalResult:
	return EvalResult.from_value(e.value)


func visit_die(e : Expr.Die) -> EvalResult:
	var count_res : EvalResult = e.count.accept(self)
	if count_res.err != null:
		return count_res
	
	var total : int = 0
	for _i : int in count_res.value:
		total += _rng.randi_range(1, e.sides)
	
	return EvalResult.from_value(total)


func visit_field(e : Expr.Field) -> EvalResult:
	match e.token:
		Lexer.TokenType.STR:
			return EvalResult.from_value(e.character.Str.get_modifier())
		Lexer.TokenType.STR_SCORE:
			return EvalResult.from_value(e.character.Str.value)
		Lexer.TokenType.DEX:
			return EvalResult.from_value(e.character.Dex.get_modifier())
		Lexer.TokenType.DEX_SCORE:
			return EvalResult.from_value(e.character.Dex.value)
		Lexer.TokenType.CON:
			return EvalResult.from_value(e.character.Con.get_modifier())
		Lexer.TokenType.CON_SCORE:
			return EvalResult.from_value(e.character.Con.value)
		Lexer.TokenType.INT:
			return EvalResult.from_value(e.character.Int.get_modifier())
		Lexer.TokenType.INT_SCORE:
			return EvalResult.from_value(e.character.Int.value)
		Lexer.TokenType.WIS:
			return EvalResult.from_value(e.character.Wis.get_modifier())
		Lexer.TokenType.WIS_SCORE:
			return EvalResult.from_value(e.character.Wis.value)
		Lexer.TokenType.CHA:
			return EvalResult.from_value(e.character.Cha.get_modifier())
		Lexer.TokenType.CHA_SCORE:
			return EvalResult.from_value(e.character.Cha.value)
		Lexer.TokenType.LEVEL:
			# TODO: Implement character level
			return EvalResult.from_value(0)
		Lexer.TokenType.PROFICIENCY:
			return EvalResult.from_value(e.character.proficiency)
		_:
			return EvalResult.from_err(Err.new(e.token, "unknown field name"))


class EvalResult:
	var value : int
	var err : Err
	
	
	static func from_value(p_value : int) -> EvalResult:
		return EvalResult.new(p_value, null)
	
	
	static func from_err(p_err : Err) -> EvalResult:
		return EvalResult.new(0, p_err)
	
	
	func _init(p_value : int, p_err : Err) -> void:
		value = p_value
		err = p_err


class Err:
	var token : Lexer.Token
	var details : String
	
	
	func _init(p_token : Lexer.Token, p_details : String) -> void:
		token = p_token
		details = p_details
