#include "syntax_tree.h"

int i;

Ast newAst(char *name, int num, ...)
{
    tnode father = (tnode)malloc(sizeof(struct treeNode));
    tnode temp = (tnode)malloc(sizeof(struct treeNode));
    if (!father)
    {
        yyerror("create treenode error");
        exit(0);
    }
    father->name = name;

    va_list list;
    va_start(list, num);

    if (num > 0)
    {
        temp = va_arg(list, tnode);
        setChildTag(temp);
        father->fchild = temp;
        father->line = temp->line;

        if (num >= 2)
        {
            for (i = 0; i < num - 1; ++i)
            {
                temp->next = va_arg(list, tnode);
                temp = temp->next;
                setChildTag(temp);
            }
        }
    }
    return father;
}

void Preorder(Ast ast, int level)
{
    if (ast != NULL)
    {
        for (i = 0; i < level; ++i)
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
    for (i = 0; i < nodeNum; i++)
    {
        if (nodeList[i] == node)
        {
            nodeIsChild[i] = 1;
        }
    }
}

int main(int argc, char **argv)
{
    int j;
    printf("start analysis\n");
    if (argc < 2)
    {
        return 1;
    }
    for (i = 1; i < argc; i++)
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
        for (j = 0; j < nodeNum; j++)
        {
            if (nodeIsChild[j] != 1)
            {
                Preorder(nodeList[j], 0);
            }
        }
    }
}
