%{
	#include<stdio.h>
	#include<stdlib.h>
	int line=1;
%}

DIGIT [0-9]
OINTEGER [1-9]{DIGIT}*

%%
\n {++line;}
{DIGIT} {printf("line%d:(integer, %s)\n",line,yytext);} 
{OINTEGER} {printf("line%d:(integer, %s)\n",line,yytext);} 
. {}
[ \t]+ {}

%%
int main(){
	yyin=fopen("E:\编译原理上机\win_flex_bison-latest\data.txt","r");
	yylex();
	return 0;
}
int yywrap(){
	return 1;
}
