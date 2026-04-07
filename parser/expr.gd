class_name Expr
extends Node
## An AST for character sheet expressions.
##
## expression -> term
## term       -> factor ( ( "+" | "-" ) factor )*
## factor     -> unary ( ( "*" | "/+" | "/-" ) unary )*
## unary      -> ( "-" ) unary | primary die?
## primary    -> "(" expression ")" | INTEGER | STR | STR_SCORE | DEX
##             | DEX_SCORE | CON | CON_SCORE | INT | INT_SCORE | WIS
##             | WIS_SCORE | CHA | CHA_SCORE | LEVEL | PROFICIENCY
## die        -> DIE


@warning_ignore("untyped_declaration")
func accept(_v : Visitor):
	pass


class Visitor:
	@warning_ignore("untyped_declaration")
	func visit_binary(_e : Expr.Binary):
		pass
	
	
	@warning_ignore("untyped_declaration")
	func visit_unary(_e : Expr.Unary):
		pass
	
	
	@warning_ignore("untyped_declaration")
	func visit_grouping(_e : Expr.Grouping):
		pass
	
	
	@warning_ignore("untyped_declaration")
	func visit_literal(_e : Expr.Literal):
		pass
	
	
	@warning_ignore("untyped_declaration")
	func visit_die(_e : Expr.Die):
		pass
	
	
	@warning_ignore("untyped_declaration")
	func visit_field(_e : Expr.Field):
		pass


class Binary extends Expr:
	var left : Expr
	var right : Expr
	var operator : Lexer.Token
	
	
	func _init(p_left : Expr, p_right : Expr, p_operator : Lexer.Token) -> void:
		left = p_left
		right = p_right
		operator = p_operator
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_binary(self)


class Unary extends Expr:
	var right : Expr
	var operator : Lexer.Token
	
	
	func _init(p_right : Expr, p_operator : Lexer.Token) -> void:
		right = p_right
		operator = p_operator
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_unary(self)


class Grouping extends Expr:
	var expr : Expr
	
	
	func _init(p_expr : Expr) -> void:
		expr = p_expr
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_grouping(self)


class Literal extends Expr:
	var value : int
	
	
	func _init(p_value : int) -> void:
		value = p_value
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_literal(self)


class Die extends Expr:
	var count : Expr
	var sides : int
	
	
	func _init(p_count : Expr, p_sides : int) -> void:
		count = p_count
		sides = p_sides
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_die(self)


class Field extends Expr:
	var character : CharacterData
	var token : Lexer.Token
	
	
	func _init(p_character : CharacterData, p_token : Lexer.Token) -> void:
		character = p_character
		token = p_token
	
	
	@warning_ignore("untyped_declaration")
	func accept(v : Visitor):
		return v.visit_field(self)
