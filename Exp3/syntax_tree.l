%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	#include"syntax_tree.h"
	#include"syntax_tree.tab.h"
%}
%option yylineno
LETTER [a-zA-Z]
IDN {LETTER}({LETTER}|[0-9])*
DEC 0|[1-9][0-9]*
HEX 0[xX][a-fA-F0-9]+
OCT 0[1-7][0-7]*
ILHEX 0[xX][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
ILOCT 0[0-7]*[89]+[0-7]*
ADD \+
SUB \-
MUL \*
DIV \/
GT \>
LT \<
EQ \=
GE \>=
LE \<=
NEQ \<>
SLP \(
SRP \)
SEMI \;
IF if
THEN then
ELSE else
WHILE while
DO do
BEGIN begin
END end
id {IDN}{DEC}|{IDN}
%%
{DEC} {yylval.type_tnode=newLeafAst("DEC",yytext,yylineno);return DEC;} 
{HEX} {yylval.type_tnode=newLeafAst("HEX",yytext,yylineno);return HEX;}
{OCT} {yylval.type_tnode=newLeafAst("OCT",yytext,yylineno);return OCT;}
{ILHEX} {printf("ILHEX_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);} 
{ILOCT} {printf("ILOCT_ERROR at line %d: charachters \"%s\"\n",yylineno,yytext);} 
{ADD} {yylval.type_tnode=newLeafAst("+",yytext,yylineno);return ADD;} 
{SUB} {yylval.type_tnode=newLeafAst("-",yytext,yylineno);return SUB;}
{MUL} {yylval.type_tnode=newLeafAst("*",yytext,yylineno);return MUL;}
{DIV} {yylval.type_tnode=newLeafAst("/",yytext,yylineno);return DIV;}
{GT} {yylval.type_tnode=newLeafAst(">",yytext,yylineno);return GT;}
{LT} {yylval.type_tnode=newLeafAst("<",yytext,yylineno);return LT;}
{EQ} {yylval.type_tnode=newLeafAst("=",yytext,yylineno);return EQ;}
{GE} {yylval.type_tnode=newLeafAst(">=",yytext,yylineno);return GE;}
{LE} {yylval.type_tnode=newLeafAst("<=",yytext,yylineno);return LE;}
{NEQ} {yylval.type_tnode=newLeafAst("<>",yytext,yylineno);return NEQ;}
{SLP} {yylval.type_tnode=newLeafAst("(",yytext,yylineno);return SLP;}
{SRP} {yylval.type_tnode=newLeafAst(")",yytext,yylineno);return SRP;}
{IF} {yylval.type_tnode=newLeafAst("IF",yytext,yylineno);return IF;}
{THEN} {yylval.type_tnode=newLeafAst("THEN",yytext,yylineno);return THEN;} 
{ELSE} {yylval.type_tnode=newLeafAst("ELSE",yytext,yylineno);return ELSE;} 
{DO} {yylval.type_tnode=newLeafAst("DO",yytext,yylineno);return DO;} 
{BEGIN} {yylval.type_tnode=newLeafAst("BEGIN",yytext,yylineno);return BEGIN;} 
{END} {yylval.type_tnode=newLeafAst("END",yytext,yylineno);return END;} 
{WHILE} {yylval.type_tnode=newLeafAst("WHILE",yytext,yylineno);return WHILE;} 
{SEMI} {yylval.type_tnode=newLeafAst(";",yytext,yylineno);return SEMI;} 
{id} {yylval.type_tnode=newLeafAst("ID",yytext,yylineno);return id;} 
. {}
[ \t]+ {}
%%
int yywrap(){
	return 1;//不考虑连续输入多个文件，故返回1
}
