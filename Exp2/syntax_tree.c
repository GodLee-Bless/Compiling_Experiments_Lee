#include "syntax_tree.h"

Ast newAst(char *name, int num, ...)
{
    tnode father = (tnode)malloc(sizeof(struct treeNode));//父结点
    tnode temp = (tnode)malloc(sizeof(struct treeNode));//子结点
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;

    va_list list;
    va_start(list, num);

    if (num > 0)//表示当前非终结符
    {
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
    }
    else //num = 0的情况，表示当前节点是终结符（叶节点）或者空的语法单元，此时num表示行号（空单元为-1）,将对应的值存入union
    {
        father->line = va_arg(list, int);//获取该节点的yylineno行号，
        /*
        if ((!strcmp(name, "ID")) || (!strcmp(name, "TYPE")))
        {
            char *str;
            str = (char *)malloc(sizeof(char) * 40);
            strcpy(str, yytext);
            father->id_type = str;
            // father->id_type = (char*)malloc(sizeof(char)*40);
            // strcpy(father->id_type,yytext);
        }
        else if (!strcmp(name, "INT"))
        {
            father->intval = atoi(yytext);
        }
        else
        {
            father->fltval = atof(yytext);
        }*/
    }
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
    printf("start analysis\n");
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
        for (int j = 0; j < nodeNum; j++)
        {
            if (nodeIsChild[j] != 1)
            {
                Preorder(nodeList[j], 0);
            }
        }
    }
}
