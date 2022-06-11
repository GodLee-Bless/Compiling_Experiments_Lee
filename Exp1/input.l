%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int line=1;
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
\n {++line;}
{ILHEX} {printf("ILHEX -\n");} 
{ILOCT} {printf("ILOCT -\n");} 
{DEC} {printf("DEC %s\n",yytext);} 
{HEX} {
			char *x = yytext;
			int num = 0, n = 0, length = strlen(yytext);
			for (int i = length - 1; i > 1; i--) {
			if (x[i] <= '9')
				num += (x[i] - '0')*pow(16, n);
			else if(x[i]>='a')
				num += (x[i] - 'a' + 10)*pow(16, n);
			else if(x[i]>='A')
				num += (x[i] - 'A' + 10)*pow(16, n);
			n++;
			}
			printf("HEX %d\n",num);
		}
{OCT} {
			char *x = yytext;
			int num = 0, n = 0, length = strlen(yytext);
			for (int i = length - 1; i > 0; i--) {
				num += (x[i] - '0')*pow(8, n);
				n++;
			}
			printf("OCT %d\n",num);
		}
{ADD} {printf("ADD -\n");} 
{SUB} {printf("SUB -\n");}
{MUL} {printf("MUL -\n");}
{DIV} {printf("DIV -\n");}
{GT} {printf("GT -\n");}
{LT} {printf("LT -\n");}
{EQ} {printf("EQ -\n");}
{GE} {printf("GE -\n");}
{LE} {printf("LE -\n");}
{NEQ} {printf("NEQ -\n");}
{SLP} {printf("SLP -\n");}
{SRP} {printf("SRP -\n");}
{IF} {printf("IF -\n");}
{THEN} {printf("THEN -\n");} 
{ELSE} {printf("ELSE -\n");} 
{DO} {printf("DO -\n");} 
{BEGIN} {printf("BEGIN -\n");} 
{END} {printf("END -\n");} 
{WHILE} {printf("WHILE -\n");} 
{IDN} {printf("IDN %s\n",yytext);} 
{SEMI} {printf("SEMI -\n");} 
. {}
[ \t]+ {}
%%
int main(){
	yyin = fopen(".\\data.txt", "r");
	yylex();
	return 0;
}
int yywrap(){
	return 1;
}
