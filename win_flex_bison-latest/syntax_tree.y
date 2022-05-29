%{
#include<unistd.h>
#include<stdio.h>   
#include "syntax_tree.h"
%}

%union{
    	tnode type_tnode;
	double d;
}
 
%token <type_tnode> DEC OCT HEX id
%token <type_tnode> ILHEX ILOCT
%token <type_tnode> ADD '+'
%token <type_tnode> SUB '-'
%token <type_tnode> MUL '*'
%token <type_tnode> DIV '/'
%token <type_tnode> LE "<="
%token <type_tnode> GE ">="
%token <type_tnode> EQ '='
%token <type_tnode> NEQ "<>"
%token <type_tnode> LT '<'
%token <type_tnode> GT '>'
%token <type_tnode> SLP '('
%token <type_tnode> SRP ')'
%token <type_tnode> SEMI ';'
%token <type_tnode> IF ELSE WHILE DO BEGIN END THEN
%type <type_tnode> P L S C E T F

%left SUB ADD SRP
%left MUL DIV
%right EQ GT LT GE LE NEQ SLP DO THEN id
   	
%%
P:L {$$=newAst("P",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|L P {$$=newAst("P",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;} 
	;
L:S {$$=newAst("L",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
S:id EQ E {$$=newAst("S",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN S ELSE S {$$=newAst("S",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN S {$$=newAst("S",3,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	|WHILE C DO S {$$=newAst("S",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	;
C:E GT E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E LT E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E EQ E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E GE E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E LE E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E NEQ E {$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
E:E ADD T {$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E SUB T {$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|T {$$=newAst("E",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
T:F {$$=newAst("T",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|T MUL F {$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|T DIV F {$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
F:SLP E SRP {$$=newAst("F",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|OCT {$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|DEC {$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|HEX {$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|id {$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
%%
