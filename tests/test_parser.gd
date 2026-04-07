extends GutTest


func print_tokens(tokens : Array[Lexer.Token]):
	for token in tokens:
		print(token)


func print_errors(errors : Array[Error]):
	for err in errors:
		print(err)


func test_lexer():
	var source = "1d4 + dex, prof - whatever/ level /- 2"
	var lexer = Lexer.new(source)
	var tokens = lexer.scanTokens()
	var errors = lexer.getErrors()
	print_tokens(tokens)
	print_errors(errors)
