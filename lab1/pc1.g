grammar pc1;

ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

INT :	'0'..'9'+
    ;

PLUS 	:	'+'
	;

MINUS 	:	'-'
	;

MUL 	:	'*'
	;

DIV 	:	'/'
	;

NL 	:	'\n'
	;

COMMENT
    :   '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}
    |   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        ) {$channel=HIDDEN;}
    ;
    
plik 	:	(expr {System.out.println("result: "+$expr.text+" = "+$expr.wy);) NL+)* EOF
	;
expr 	returns [Integer wy]
	:	t1=term {$wy = $t1.wy;}
		( PLUS term ({term}? {$wy += 5;}
		| {$wy += 10;}
	;
	
term 	returns [Integer wy]
	:	a1=atom {$wy = $a1.wy;}
		( MUL term ({term}? {$wy += 5;}
		| {$wy += 10;}
	;
atom 	:	INT
	;
