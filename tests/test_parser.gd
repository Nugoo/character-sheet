extends GutTest


func print_tokens(tokens : Array[Lexer.Token]) -> void:
	for token : Lexer.Token in tokens:
		print(token)


func print_errors(errors : Array[Lexer.Err]) -> void:
	for err : Lexer.Err in errors:
		print(err)


func test_lexer() -> void:
	var source : String = "1d4 + dex, prof - whatever/ level /- 2d"
	var lexer : Lexer = Lexer.new(source)
	var tokens : Array[Lexer.Token] = lexer.scanTokens()
	var errors : Array[Lexer.Err] = lexer.getErrors()
	print_tokens(tokens)
	print_errors(errors)


class ExprPrinter extends Expr.Visitor:
	func visit_binary(e : Expr.Binary) -> String:
		return "(%s %s %s)" % [e.left.accept(self), e.operator._lexeme, e.right.accept(self)]
	
	
	func visit_unary(e : Expr.Unary) -> String:
		if e.operator != null:
			return "(%s %s)" % [e.operator._lexeme, e.right.accept(self)]
		else:
			return e.right.accept(self)
	
	
	func visit_grouping(e : Expr.Grouping) -> String:
		return "(%s)" % e.expr.accept(self)
	
	
	func visit_literal(e : Expr.Literal) -> String:
		return "%s" % e.value
	
	
	func visit_die(e : Expr.Die) -> String:
		return "(%s)d%s" % [e.count.accept(self), e.sides]


func test_parser() -> void:
	var character : CharacterData = CharacterData.new()
	var source : String = "(3+5)/-7"
	var lexer : Lexer = Lexer.new(source)
	var tokens : Array[Lexer.Token] = lexer.scanTokens()
	assert_eq(lexer.getErrors().size(), 0)
	var parser : Parser = Parser.new(character, tokens)
	var res : Parser.ParseResult = parser.parse_expression()
	if res.err != null:
		print(res.err)
		return
	var printer : ExprPrinter = ExprPrinter.new()
	var s : String = res.expr.accept(printer)
	print(s)
