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
%token <type_tnode> ADD
%token <type_tnode> SUB
%token <type_tnode> MUL
%token <type_tnode> DIV
%token <type_tnode> LE
%token <type_tnode> GE
%token <type_tnode> EQ
%token <type_tnode> NEQ
%token <type_tnode> LT
%token <type_tnode> GT
%token <type_tnode> SLP
%token <type_tnode> SRP 
%token <type_tnode> SEMI 
%token <type_tnode> IF ELSE WHILE DO BEGIN END THEN
%type <type_tnode> P L S C E T F W

%left  SRP SUB ADD SLP
%left MUL DIV 
%left THEN DO 
%left EQ GT LT GE LE NEQ 
%right IF WHILE
%nonassoc SEMI	

%%
P:L {printf("P:L\n");$$=newAst("P",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|L P {printf("P:L P\n");$$=newAst("P",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;} 
	;
L:S {printf("L:S\n");$$=newAst("L",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
S:id EQ E {printf("S:id = E\n");$$=newAst("S",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN W ELSE S {printf("S:IF C THEN W ELSE S\n");$$=newAst("S",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN S {printf("S:IF C THEN S\n");$$=newAst("S",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	|WHILE C DO S {printf("S:WHILE C DO S\n");$$=newAst("S",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	;
W:id EQ E {printf("W:id = E\n");$$=newAst("W",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN W ELSE W {printf("W:IF C THEN W ELSE W\n");$$=newAst("W",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
	|WHILE C DO W {printf("W:WHILE C DO W\n");$$=newAst("W",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;}
	;
C:E GT E {printf("C:E > E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E LT E {printf("C:E < E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E EQ E {printf("C:E = E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E GE E {printf("C:E >= E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E LE E {printf("C:E <= E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E NEQ E {printf("C:E <> E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
E:E ADD T {printf("E:E+T\n");$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|E SUB T {printf("E:E-T\n");$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|T {printf("E:T\n");$$=newAst("E",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
T:F {printf("T:F\n");$$=newAst("T",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|T MUL F {printf("T:T*F\n");$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|T DIV F {printf("T:T/F\n");$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	;
F:SLP E SRP {printf("F:(E)\n");$$=newAst("F",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|OCT {printf("F:OCT\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|DEC {printf("F:DEC\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|HEX {printf("F:HEX\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	|id {printf("F:id\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;}
	;
%%
