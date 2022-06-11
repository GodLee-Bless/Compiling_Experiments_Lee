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
%type <type_tnode> P L S C E T F W SS

%left SRP SUB ADD SLP
%left MUL DIV 
%left THEN DO 
%left EQ GT LT GE LE NEQ 
%right IF WHILE
%nonassoc SEMI	

%%
SS      :P{	
		printf("SS:P\n");$$=newAst("SS",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		strcat($$->code,$1->code);
		
		//删去最终代码中重复的label
		for(int i = 0; i < label_count; i++){
			char* rplabel = (char*)malloc(20);
			char* label = (char*)malloc(20);
			memset(rplabel, 0 ,sizeof(char)*20);
			memset(label, 0 ,sizeof(char)*20);
			
			/*strcat(rplabel,label_Tran(i));
			strcat(rplabel,":\n");
			strcat(rplabel,label_Tran(i));
			strcat(rplabel,":");			
			strcat(label,label_Tran(i));
			strcat(label,":");*/
			sprintf(rplabel,"%s: \n%s:",label_Tran(i),label_Tran(i));
			sprintf(label,"%s:",label_Tran(i));
			printf("a = \n%s\nb = \n%s\n",rplabel,label);
			strrpc($$->code,rplabel,label);
		}
		
		
		printf("\n\n\n%s",$$->code);
		}
	;	

P       :L{
		printf("P:L\n");$$=newAst("P",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		
		//P.label = L.label
		$$->label = $1->label;
		
		strcat($$->code,$1->code);//P.code = L.code
		//printf("\n\n\n%s",$$->code);
		}
	|L P {
		printf("P:L P\n");$$=newAst("P",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;
		
		//P.begin = L.begin ; P.next = P1.next;
		$$->label.l_begin = $1->label.l_begin;
		$$->label.l_next = $1->label.l_next;		
		
		strcat($$->code,$1->code);//P.code = L.code ||
		strcat($$->code,$2->code);//P1.code
		
		//用P1.begin回填L.next
		strrpc($$->code,label_Tran($1->label.l_next),label_Tran($2->label.l_begin));
		
		
		//printf("\n\n\n%s",$$->code);
		} 
	;
	
L       :S SEMI {
		printf("L:S SEMI\n");$$=newAst("L",2,$1,$2);nodeList[nodeNum]=$$;nodeNum++;	
		
		//L.label = S.label
		$$->label = $1->label;
		
		strcat($$->code,$1->code);//L.code = S.code		
		//gen(S.next ':')
		strcat($$->code,label_Tran($1->label.l_next));
		strcat($$->code,": \n");
		//printf("\n\n\n%s",$$->code);
		}
	;
	
S       :id EQ E {
		printf("S:id = E\n");$$=newAst("S",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		newlabel(&($$->label.l_next));//newlabel(s.next)
		newlabel(&($$->label.l_begin));//newlabel(s.begin)
				
		strcat($$->code,$3->code);//S.code = E.code
		//gen(id.place ':=' E.place)
		strcat($$->code,$1->content);
		strcat($$->code," := ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code,"\n");
		//printf("\n\n\n%s",$$->code);
		}
	|IF C THEN W ELSE S {printf("S:IF C THEN W ELSE S\n");$$=newAst("S",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN S {
		printf("S:IF C THEN S\n");$$=newAst("S",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;
		newlabel(&($$->label.l_begin));
		$$->label.l_next = $4->label.l_next;//S.next = S1.next
		
		
		strcat($$->code,$2->code);//S.code = C.code ||
		//gen(C.true ':') ||
		strcat($$->code,label_Tran($2->label.l_true));
		strcat($$->code,": \n");
		strcat($$->code,$4->code);// S1.code
		
		//用S.next 回填 C.false
		strrpc($$->code,label_Tran($2->label.l_false),label_Tran($$->label.l_next));
		//用S1.begin 回填 C.true
		strrpc($$->code,label_Tran($2->label.l_true),label_Tran($4->label.l_begin));
		
		}
	|WHILE C DO S {
		printf("S:WHILE C DO S\n");$$=newAst("S",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;
		
		$$->label.l_next = $2->label.l_false;
		$$->label.l_begin = $4->label.l_next;
		
		//S.code = gen(S.begin ':') ||
		strcat($$->code,label_Tran($$->label.l_begin));
		strcat($$->code,": \n");
		strcat($$->code,$2->code);//C.code ||
		//gen(C.true ':') ||
		strcat($$->code,label_Tran($2->label.l_true));
		strcat($$->code,": \n");
		strcat($$->code,$4->code);//S1.code ||
		//gen('goto' S.begin)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_begin));
		strcat($$->code,"\n");
		//printf("\n\n\n%s\n\n\n",$$->code);
		
		//S1.begin 回填 C.true
		strrpc($$->code,label_Tran($2->label.l_true),label_Tran($4->label.l_begin));
		//printf("\n\n\n%s",$$->code);
		
		}
	;
	
W:id EQ E {printf("W:id = E\n");$$=newAst("W",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;}
	|IF C THEN W ELSE W {printf("W:IF C THEN W ELSE W\n");$$=newAst("W",6,$1,$2,$3,$4,$5,$6);nodeList[nodeNum]=$$;nodeNum++;}
	|WHILE C DO W {
		printf("W:WHILE C DO W\n");$$=newAst("W",4,$1,$2,$3,$4);nodeList[nodeNum]=$$;nodeNum++;
		/*char temp[50];
		newlabel(&($$->label_begin));
		$$->label_next = $2->label_false;
		$4->label_begin = $$->label_next;
		sprintf(temp,"%d",$$->label_begin);
		strcat($$->code,temp);
		strcat($$->code,": \n");
		strcat($$->code,$2->code);
		strcat($$->code,"\n");
		
		sprintf(temp,"%d",$2->label_true);
		strcat($$->code,temp);
		strcat($$->code,": \n");
		strcat($$->code,$4->code);
		strcat($$->code,"\n");
		strcat($$->code,"goto L");
		sprintf(temp,"%d",$$->label_begin);
		strcat($$->code,temp);
		//printf($$->code.c);*/
		}
	;
	
C       :E GT E {
		printf("C:E > E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		char temp[10];
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘>’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," > ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	|E LT E {
		printf("C:E < E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		char temp[10];
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘<’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," < ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	|E EQ E {
		printf("C:E = E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		char temp[10];
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘=’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," = ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	|E GE E {
		printf("C:E >= E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		char temp[10];
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘>=’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," >= ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	|E LE E {
		printf("C:E <= E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘<=’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," <= ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	|E NEQ E {
		printf("C:E <> E\n");$$=newAst("C",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		newlabel(&($$->label.l_true));
		newlabel(&($$->label.l_false));
		strcat($$->code,$1->code);// C.code = E1.code ||
		strcat($$->code,$3->code);// E2.cide ||
		//gen(‘if’ E1.place ‘!=’ E2.place ‘goto’ C.true) || 
		strcat($$->code,"if ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," != ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code," goto ");
		strcat($$->code,label_Tran($$->label.l_true));
		strcat($$->code,"\n");
		//gen(‘goto’ C.false)
		strcat($$->code,"goto ");
		strcat($$->code,label_Tran($$->label.l_false));
		strcat($$->code,"\n");
		}
	;
	
E       :E ADD T {
		printf("E:E+T\n");$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		//newtemp
		$$->place.flag = 2;
		newtemp(&($$->place.temp));
		
		//E.code = 
		strcat($$->code,$1->code);//E1.code ||
		strcat($$->code,$3->code);//T.code
		//E.place ‘:=’ E1.place ‘+’ T.place
		strcat($$->code,getPlaceStr($$));
		strcat($$->code," := ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," + ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code,"\n");
		}
	|E SUB T {
		printf("E:E-T\n");$$=newAst("E",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		//newtemp
		$$->place.flag = 2;
		newtemp(&($$->place.temp));
		
		//E.code = 
		strcat($$->code,$1->code);//E1.code ||
		strcat($$->code,$3->code);//T.code
		//E.place ‘:=’ E1.place ‘-’ T.place
		strcat($$->code,getPlaceStr($$));
		strcat($$->code," := ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," - ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code,"\n");
		}
	|T {
		printf("E:T\n");$$=newAst("E",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		$$->place = $1->place;
		strcat($$->code,$1->code);
		}
	;
	
T       :F {
		printf("T:F\n");$$=newAst("T",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		$$->place = $1->place;//T.place = F.place
		strcat($$->code,$1->code);//T.code = F.code
		}
	|T MUL F {
		printf("T:T*F\n");$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		//newtemp
		$$->place.flag = 2;
		newtemp(&($$->place.temp));
		
		//T.code = 
		strcat($$->code,$1->code);//T1.code ||
		strcat($$->code,$3->code);//F.code
		//T.place ‘:=’ T1.place ‘*’ F.place
		strcat($$->code,getPlaceStr($$));
		strcat($$->code," := ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," * ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code,"\n");
		}
	|T DIV F {
		printf("T:T/F\n");$$=newAst("T",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		//newtemp
		$$->place.flag = 2;
		newtemp(&($$->place.temp));
		
		//T.code = 
		strcat($$->code,$1->code);//T1.code ||
		strcat($$->code,$3->code);//F.code
		//T.place ‘:=’ T1.place ‘/’ F.place
		strcat($$->code,getPlaceStr($$));
		strcat($$->code," := ");
		strcat($$->code,getPlaceStr($1));
		strcat($$->code," / ");
		strcat($$->code,getPlaceStr($3));
		strcat($$->code,"\n");
		}
	;
	
F       :SLP E SRP {
		printf("F:(E)\n");$$=newAst("F",3,$1,$2,$3);nodeList[nodeNum]=$$;nodeNum++;
		$$->place = $2->place;//F.place = E.place
		strcat($$->code,$2->code);//F.code = E.code
		}
	|OCT {
		printf("F:OCT\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		char *endptr;
		$$->place.flag = 1;//该节点为常数值结点，flag取1
		$$->place.value.flag = 1;//该节点为十六进制，value的flag取1
		$$->place.value.v = (int)strtol($1->content, &endptr, 8);//赋值
		}
	|DEC {
		printf("F:DEC\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		char *endptr;
		$$->place.flag = 1;//该节点为常数值结点，flag取1
		$$->place.value.flag = 0;//该节点为十六进制，value的flag取0
		$$->place.value.v = (int)strtol($1->content, &endptr, 10);//赋值
		}
	|HEX {
		printf("F:HEX\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		char *endptr;
		$$->place.flag = 1;//该节点为常数值结点，flag取1
		$$->place.value.flag = 2;//该节点为十六进制，value的flag取2
		$$->place.value.v = (int)strtol($1->content, &endptr, 16);//赋值
		}
	|id {
		printf("F:id\n");$$=newAst("F",1,$1);nodeList[nodeNum]=$$;nodeNum++;
		$$->place.flag = 0;//该节点为变量名结点，flag取0
		strcpy($$->place.id_name,$1->content);//读取叶结点的变量字符串
		}
	;
%%
