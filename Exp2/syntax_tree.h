#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern int yylineno;
extern char* yytext;
void yyerror(char const*msg);

typedef struct treeNode{
    int line;
    char* name;
    struct treeNode *fchild,*next;
    union{
        char* id_type;
        int intval;
        float fltval;
    };
}* Ast,* tnode;

Ast newAst(char* name,int num,...);

void Preorder(Ast ast,int level);

int nodeNum;
tnode nodeList[5000];
int nodeIsChild[5000];
void setChildTag(tnode node);

int hasFault;