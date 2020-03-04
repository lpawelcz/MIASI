grammar pc1;

@header {
package test;
import java.util.HashMap;
}

@lexer::header {package test;}

@members {
/** Map variable name to Integer object holding value */
HashMap memory = new HashMap();
}

ID	:	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
INT	:	'0'..'9'+;
PLUS 	:	'+';
MINUS 	:	'-';
MUL 	:	'*';
DIV 	:	'/';
SHR	:	'>>';
SHL	:	'<<';
AND	:	'&';
XOR	:	'^';
OR	:	'|';
NL 	:	'\n';
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;} | '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;};
WS	:	( ' ' | '\t' | '\r' ) {$channel=HIDDEN;};
    
plik 	:	(line)+ EOF;

line	:
	expr NL {
		System.out.println("line result:" + $expr.out);
	} |
	ID '=' expr NL {
		memory.put($ID.text, new Integer($expr.out));
	} |
	NL;
		
expr returns [int out]:
	b = expr_bit {
		$out = $b.out;
	};

expr_bit returns [int out]:
	s = expr_shift {
		$out = $s.out;
	}
	(AND s = expr_shift {
		$out &= $s.out;
	} |
	XOR s = expr_shift {
		$out ^= $s.out;
	} |
	OR s = expr_shift {
		$out |= $s.out;
	}
	)*;

expr_shift returns [int out]:
	a = expr_add {
		$out = $a.out;
	}
	( SHR a = expr_add {
		$out >>= $a.out;
	} |
	SHL a = expr_add {
		$out <<= $a.out;
	})*;
	
expr_add returns [int out]:
	m = expr_mul {
		$out = $m.out;
	}
	(PLUS m = expr_mul {
		$out += $m.out;
	} |
	MINUS m = expr_mul {
		$out -= $m.out;
	})*;
	
expr_mul returns [int out]:
	u = expr_u {
		$out = $u.out;
	}
	(MUL u = expr_u {
		$out *= $u.out;
	} |
	DIV u = expr_u {
		$out /= $u.out;
	}
	)*;
	

expr_u	returns [int out]:
	a = atom {
		$out = $a.out;
	} |
	MINUS a = atom {
		$out = -$a.out;
	};

atom returns [int out]:
	INT {
		$out = Integer.parseInt($INT.text);
	} |
	ID {
		Integer o = (Integer)memory.get($ID.text);
		if (o != null)
			$out = o.intValue();
		else
			System.err.println("variable " + $ID.text + " is not defined");
	} | 
	'(' e = expr ')' {
		$out = $e.out;
	};
