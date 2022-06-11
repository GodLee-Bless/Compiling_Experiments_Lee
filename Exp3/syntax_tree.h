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
    int line;// 行数
    char* name;// Token类型
    char content[1024];// 生成该节点时所识别的字串(仅叶结点独有)
    struct treeNode *fchild,*next;// fchild是第一个孩子节点，next是兄弟节点，使用孩子兄弟表示法
    char code[1024];//代码内容
    //int label_true, label_false, label_begin, label_next;
    
    //标签值
    struct LABEL {//四种label
    	int l_true;
    	int l_false;
    	int l_begin;
    	int l_next;    
    }label;
    
    //具体值
    struct Place {
    	char id_name[100];//变量名
    	//常数值
    	struct Value{
    		int v;//值的大小
    		int flag;//判断值的表示方式：0-DEC;1-OCT;2-HEX
    	}value;
    	int temp;//临时变量
	int flag;//判断取是变量还是常数,0表示为变量名1表示为常数值2表示为临时变量
    }place;
    
    
    
    /*struct Code {//代码
	//bool isgoto;
	char c[1024];
	int L;
    }code;*/
}* Ast,* tnode;

// 构造抽象语法树(节点)
Ast newAst(char* name,int num,...);//非终结符结点构造
Ast newLeafAst(char *name,char *yytext, int lineno);//终结符结点构造

// 先序遍历语法树
void Preorder(Ast ast,int level);
// 新申请一个标签
void newlabel(int *ast_label);
//将label对应的编号转为正规形式 如：155 -> _Ae5
char* label_Tran(int label_num);
// 新申请一个临时变量
void newtemp(int *ast_temp);
//返回一个结点的place值对应的字符串
char* getPlaceStr(Ast ast);
//替换字符串中的字符串
char *strrpc(char *str,char *oldstr,char *newstr);
//删去重复的label
//void del_RepeatLabel();


// 所有节点数量
int nodeNum;
// 存放所有节点
tnode nodeList[5000];
int nodeIsChild[5000];
// label数组
int label_list[1000];//元素为1表示该元素所对应下标已被用作lable
// label数量
int label_count;
// temp数组
int temp_list[1000];//元素为1表示该元素所对应下标已被用作临时变量
// 设置节点打印状态
void setChildTag(tnode node);

// bison是否有词法语法错误
int hasFault;

