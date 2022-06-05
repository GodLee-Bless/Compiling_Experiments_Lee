#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>  // 变长参数函数 头文件
#include <string.h>

// 当前读取字串所在行数
extern int yylineno;
// 当前识别字串
extern char* yytext;
// 错误处理
void yyerror(char const*msg);

// 抽象语法树
typedef struct treeNode{
    // 行数
    int line;
    // Token类型
    char* name;
    // fchild是第一个孩子节点，next是兄弟节点，使用孩子兄弟表示法
    struct treeNode *fchild,*next;
    // 联合体，同一时间只能保存一个成员的值，分配空间是其中最大类型的内存大小
    struct Place {//具体值
    	char id_name[100];//变量名
    	int value;//变量的值
	int t;
	int flag;//判断取是变量还是具体值
    }place;
    struct Code {//代码
	bool isgoto;
	char c[1024];
	int L;
    }code;
}* Ast,* tnode;

// 构造抽象语法树(节点)
Ast newAst(char* name,int num,...);

// 先序遍历语法树
void Preorder(Ast ast,int level);

// 所有节点数量
int nodeNum;
// 存放所有节点
tnode nodeList[5000];
int nodeIsChild[5000];
// 设置节点打印状态
void setChildTag(tnode node);

// bison是否有词法语法错误
int hasFault;

