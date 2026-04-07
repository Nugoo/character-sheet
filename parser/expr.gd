class_name Expr
extends Node
## An AST for character sheet expressions.
##
## expression -> term
## term       -> factor ( ( "+" | "-" ) factor )*
## factor     -> unary ( ( "*" | "/+" | "/-" ) unary )*
## unary      -> ( "-" ) unary | primary
## primary    -> "(" expression ")" | INTEGER | DICE | STR | STR_SCORE | STR_SAVE
##             | DEX | DEX_SCORE | DEX_SAVE | CON | CON_SCORE | CON_SAVE | INT
##             | INT_SCORE | INT_SAVE | WIS | WIS_SCORE | WIS_SAVE | CHA
##             | CHA_SCORE | CHA_SAVE | LEVEL | PROFICIENCY


class Visitor:
	func visit_binary(e : Expr.Binary):
		pass
	
	
	func visit_unary(e : Expr.Unary):
		pass
	
	
	func visit_grouping(e : Expr.Grouping):
		pass


class Binary:
	var left : Expr
	var right : Expr
	var operator : Lexer.Token
	
	
	func _init(p_left : Expr, p_right : Expr, p_operator : Lexer.Token):
		left = p_left
		right = p_right
		operator = p_operator
	
	
	func accept(v : Visitor):
		v.visit_binary(self)


class Unary:
	var right : Expr
	var operator : Lexer.Token
	
	
	func _init(p_right : Expr, p_operator : Lexer.Token):
		right = p_right
		operator = p_operator
	
	
	func accept(v : Visitor):
		v.visit_unary(self)


class Grouping:
	var expr : Expr
	
	
	func _init(p_expr : Expr):
		expr = p_expr
	
	
	func accept(v : Visitor):
		v.visit_grouping(self)


class Literal:
	var value
