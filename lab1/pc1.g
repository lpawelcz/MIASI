grammar pc1;

ID	:	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
INT	:	'0'..'9'+;
PLUS 	:	'+';
MINUS 	:	'-';
MUL 	:	'*';
DIV 	:	'/';
NL 	:	'\n';
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;} | '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;};
WS	:	( ' ' | '\t' | '\r' ) {$channel=HIDDEN;};
    
plik 	:	(line)+ EOF;
// plik 	:	(expr {System.out.println("result: "+$expr.text+" = "+$expr.wy);) NL+)* EOF
line	:	expr NL;
expr 	:	expr1;
expr1	:	expr_mul (PLUS expr_mul | MINUS expr_mul)*;
expr_mul:	expr_u (MUL expr_u | DIV expr_u)*;
expr_u	:	atom | MINUS atom;
atom	:	INT | '(' expr ')';
