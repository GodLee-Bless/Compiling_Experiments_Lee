#include "syntax_tree.h"


Ast newAst(char *name,int num, ...)//非终结符结点构造
{
    tnode father = (tnode)malloc(sizeof(struct treeNode));//父结点
    tnode temp = (tnode)malloc(sizeof(struct treeNode));//子结点
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;//获取结点类型
    
    va_list list;
    va_start(list, num);
    temp = va_arg(list, tnode);//获取当前参数列表中第一个结点
    
    setChildTag(temp);//设置相应结点tag
    father->fchild = temp;
    father->line = temp->line;

    if (num >= 2)//子结点大于1个，横向存放为第一个子结点的兄弟结点
    {
        for (int i = 0; i < num - 1; ++i)
        {
            temp->next = va_arg(list, tnode);
            temp = temp->next;
            setChildTag(temp);
        }
    }
    return father;
}

Ast newLeafAst(char *name,char *yytext, int lineno)//终结符结点构造
{
    tnode father = (tnode)malloc(sizeof(struct treeNode));
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;//获取该结点类型
    strcpy(father->content,yytext);//获取识别该节点的字串
    father->line = lineno;//获取该节点的yylineno行号，

    return father;
}


void Preorder(Ast ast, int level)
{
    if (ast != NULL)
    {
        for (int i = 0; i < level; ++i)
        {
            printf("   ");
        }
        if (ast->line != -1)
        {
            printf("%s", ast->name);
        }
        printf("\n");
        Preorder(ast->fchild, level + 1);
        Preorder(ast->next, level);
    }
}

// 新申请一个标签
void newlabel(int *ast_label){
	int i;
	for(i = 1; i < 1000; i++){//第0号保留
		if(label_list[i] == 1)
			continue;
		else{
			label_list[i] = 1;
			*ast_label = i; 
			return;
		}
	}
	perror("No availiable label!\n");//标签不足报错
}

// 新申请一个临时变量
void newtemp(int *ast_temp){
	int i;
	for(i = 1; i < 1000; i++){//第0号保留
		if(temp_list[i] == 1)
			continue;
		else{
			temp_list[i] = 1;
			*ast_temp = i; 
			return;
		}
	}
	perror("No availiable tempvar!\n");//变量不足报错
}

//返回一个结点的place值对应的字符串
char* getPlaceStr(Ast ast){
	if(ast->place.flag == 0){//变量
		return ast->place.id_name;
	}
	else if(ast->place.flag == 1){//常数
		char * tempstr = (char*)malloc(11);
		memset(tempstr, 0 ,sizeof(char)*10);
		/*if(ast->place.value.flag == 0){//DEC*/
			sprintf(tempstr,"%d",ast->place.value.v);
			return tempstr;
		/*}*//*
		else if(ast->place.value.flag == 1){//OCT
			sprintf(tempstr,"%#o",ast->place.value.v);
			return tempstr;
		}
		else{//HEX
			sprintf(tempstr,"%#x",ast->place.value.v);
			return tempstr;
		}*/
	}
	else{//临时变量
		char * tempstr = (char*)malloc(11);
		memset(tempstr, 0 ,sizeof(char)*10);
		sprintf(tempstr,"t%d",ast->place.temp);
		return tempstr;
		
	}
}

/* 功  能：将str字符串中的oldstr字符串替换为newstr字符串
 * 参  数：str：操作目标 oldstr：被替换者 newstr：替换者
 * 返回值：返回替换之后的字符串
 */
char *strrpc(char *str,char *oldstr,char *newstr){
    char bstr[strlen(str)];//转换缓冲区
    memset(bstr,0,sizeof(bstr));
 
    for(int i = 0;i < strlen(str);i++){
        if(!strncmp(str+i,oldstr,strlen(oldstr))){//查找目标字符串
            strcat(bstr,newstr);
            i += strlen(oldstr) - 1;
        }else{
        	strncat(bstr,str + i,1);//保存一字节进缓冲区
	    }
    }
 
    strcpy(str,bstr);
    return str;
}

void yyerror(char const*msg)
{
    hasFault = 1;
    fprintf(stderr, "Error type B at Line %d, %s ,before %s\n", yylineno, msg, yytext);
}

void setChildTag(tnode node)
{
    int i;
    for (int i = 0; i < nodeNum; i++)
    {
        if (nodeList[i] == node)
        {
            nodeIsChild[i] = 1;
        }
    }
}

int main(int argc, char **argv)
{
    //初始化label_list
    for(int i = 0; i < 1000; i++){
    	label_list[i] = 0;
    }
    printf("start analysis!\n");
    if (argc < 2)
    {
        return 1;
    }
    for (int i = 1; i < argc; i++)
    {
        nodeNum = 0;
        memset(nodeList, 0, sizeof(tnode) * 5000);
        memset(nodeIsChild, 0, sizeof(int) * 5000);
        hasFault = 0;

        FILE *f = fopen(argv[i], "r");
        if (!f)
        {
            perror(argv[i]);
            return 1;
        }
        yyrestart(f);
        yyparse();
        fclose(f);

        if (hasFault)
            continue;
        /*for (int j = 0; j < nodeNum; j++)
        {
            if (nodeIsChild[j] != 1)
            {
                Preorder(nodeList[j], 0);
            }
        }*/
    }
}
