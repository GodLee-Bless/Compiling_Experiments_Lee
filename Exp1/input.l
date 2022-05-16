//定义部分
/*头文件和变量声明*/
%{

%}
/*设置flex属性*/
%option yylineno
/*正则表达式定义*/
DEC 0|[1-9][0-9]*/*十进制*/
HEX 0[xX][a-fA-F0-9]+/*十六进制*/
OCT 0[1-7][0-7]*/*八进制*/
ILHEX 0[xX][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*/*非法十六进制*/
ILOCT 0[0-7]*[89]+[0-7]*/*非法八进制*/
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
END end/*运算符、分隔符和关键字*/
%%
//规则部分
%%
//用户代码部分