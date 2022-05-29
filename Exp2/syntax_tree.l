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
%%
{DEC} {yylval.type_tnode=newAst("DEC",0,yylineno);return DEC;} 
{HEX} {yylval.type_tnode=newAst("HEX",0,yylineno);return HEX;}
{OCT} {yylval.type_tnode=newAst("OCT",0,yylineno);return OCT;}
{ILHEX} {yylval.type_tnode=newAst("ILHEX",0,yylineno);return ILHEX;} 
{ILOCT} {yylval.type_tnode=newAst("ILOCT",0,yylineno);return ILOCT;} 
{ADD} {yylval.type_tnode=newAst("ADD",0,yylineno);return ADD;} 
{SUB} {yylval.type_tnode=newAst("SUB",0,yylineno);return SUB;}
{MUL} {yylval.type_tnode=newAst("MUL",0,yylineno);return MUL;}
{DIV} {yylval.type_tnode=newAst("DIV",0,yylineno);return DIV;}
{GT} {yylval.type_tnode=newAst("GT",0,yylineno);return GT;}
{LT} {yylval.type_tnode=newAst("LT",0,yylineno);return LT;}
{EQ} {yylval.type_tnode=newAst("EQ",0,yylineno);return EQ;}
{GE} {yylval.type_tnode=newAst("GE",0,yylineno);return GE;}
{LE} {yylval.type_tnode=newAst("LE",0,yylineno);return LE;}
{NEQ} {yylval.type_tnode=newAst("NEQ",0,yylineno);return NEQ;}
{SLP} {yylval.type_tnode=newAst("SLP",0,yylineno);return SLP;}
{SRP} {yylval.type_tnode=newAst("SRP",0,yylineno);return SRP;}
{IF} {yylval.type_tnode=newAst("IF",0,yylineno);return IF;}
{THEN} {yylval.type_tnode=newAst("THEN",0,yylineno);return THEN;} 
{ELSE} {yylval.type_tnode=newAst("ELSE",0,yylineno);return ELSE;} 
{DO} {yylval.type_tnode=newAst("DO",0,yylineno);return DO;} 
{BEGIN} {yylval.type_tnode=newAst("BEGIN",0,yylineno);return BEGIN;} 
{END} {yylval.type_tnode=newAst("END",0,yylineno);return END;} 
{WHILE} {yylval.type_tnode=newAst("WHILE",0,yylineno);return WHILE;} 
{IDN} {yylval.type_tnode=newAst("IDN",0,yylineno);return IDN;} 
{SEMI} {yylval.type_tnode=newAst("SEMI",0,yylineno);return SEMI;} 
. {}
[ \t]+ {}
%%
int yywrap(){
	return 1;
}
