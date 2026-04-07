class_name TypeChecker
extends Expr.Visitor

enum Type {
	INTEGER,
	RANDOM_VALUE,
	ERROR,
}


func visit_binary(e : Expr.Binary) -> TypeResult:
	var left_res : TypeResult = e.left.accept(self)
	if left_res.err != null:
		return left_res
	var right_res : TypeResult = e.right.accept(self)
	if right_res.err != null:
		return right_res
	
	match e.operator.type():
		Lexer.TokenType.PLUS, Lexer.TokenType.MINUS, Lexer.TokenType.ASTERISK:
			if left_res.type == Type.RANDOM_VALUE or right_res.type == Type.RANDOM_VALUE:
				return TypeResult.from_type(Type.RANDOM_VALUE)
			elif left_res.type == Type.INTEGER and right_res.type == Type.INTEGER:
				return TypeResult.from_type(Type.INTEGER)
			else:
				return TypeResult.from_err(Err.new(e.operator, 
					"unexpected types %s and %s for operator %s" % [
						left_res.type, right_res.type, e.operator.type()
					],
				))
		Lexer.TokenType.DIV_PLUS, Lexer.TokenType.DIV_MINUS:
			if right_res.type != Type.INTEGER:
				return TypeResult.from_err(Err.new(e.operator, "cannot divide by non-integer"))
			else:
				return left_res
		_:
			return TypeResult.from_err(Err.new(e.operator, "unknown operator"))


func visit_unary(e : Expr.Unary) -> TypeResult:
	return e.right.accept(self)


func visit_grouping(e : Expr.Grouping) -> TypeResult:
	return e.expr.accept(self)


func visit_literal(_e : Expr.Literal) -> TypeResult:
	return TypeResult.from_type(Type.INTEGER)


func visit_die(_e : Expr.Die) -> TypeResult:
	return TypeResult.from_type(Type.RANDOM_VALUE)


func visit_field(_e : Expr.Field) -> TypeResult:
	return TypeResult.from_type(Type.INTEGER)


class TypeResult:
	var type : Type
	var err : Err
	
	
	static func from_type(p_type : Type) -> TypeResult:
		return TypeResult.new(p_type, null)
	
	
	static func from_err(p_err : Err) -> TypeResult:
		return TypeResult.new(Type.ERROR, p_err)
	
	
	func _init(p_type : Type, p_err : Err) -> void:
		type = p_type
		err = p_err


class Err:
	var token : Lexer.Token
	var details : String
	
	
	func _init(p_token : Lexer.Token, p_details : String) -> void:
		token = p_token
		details = p_details
