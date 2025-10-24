%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct TreeNode{
    char* data;
    struct TreeNode *left, *right;
} TreeNode;

TreeNode* makeNode(char*, TreeNode*, TreeNode*);
void print_preorder(TreeNode*, int); 
void delTree(TreeNode*);

extern int yylex();
extern int yylineno;
extern char *yytext;

int yyerror(const char *msg);
%}

%union {
    char *str;
    struct TreeNode* TreeNode;
}

/* --- tokens --- */
%token <str> CLASS CREATE FEATURE DO END 
%token <str> IF THEN ELSE FROM UNTIL LOOP PRINT
%token <str> IDENTIFIER RESERVED_TYPE NUMBER STRING REAL TRUE FALSE
%token <str> PLUS MINUS TIMES DIVIDE ASSIGN EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%token <str> NOT NOT_EQUAL AND OR
%token <str> PARENTHESIS_OPEN PARENTHESIS_CLOSE COLON COMMA COMMENT
%token <str> UNKNOWN

%type <TreeNode> STATEMENT_LIST BLOCK FEATURE_DEF FEATURE_LIST CLASS_DEF PROGRAM

%left EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT_EQUAL
%left AND OR
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT   /* negación unaria */

%%

PROGRAM: CLASS_DEF { print_preorder($1,0); } ;

CLASS_DEF: CLASS IDENTIFIER FEATURE_LIST END { 
    TreeNode *class_name = makeNode($2, NULL, NULL);
    $$ = makeNode("CLASS_DEF", class_name, $3);
} ;

FEATURE_LIST:  FEATURE_DEF FEATURE_LIST { $$ = makeNode("FEATURE_LIST", $1, $2); }
             | FEATURE_DEF { $$ = $1; } ;

FEATURE_DEF: FEATURE IDENTIFIER BLOCK {
    TreeNode* name = makeNode($2, NULL, NULL);
    $$ = makeNode("FEATURE_DEF", name, $3);
} ;

BLOCK: DO STATEMENT_LIST END {
    $$ = makeNode("BLOCK", NULL, $2);
} ;

STATEMENT_LIST: /* EMPTY */ {$$ = NULL;} ;

%%

int main(void) {
    return yyparse();
}

int yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "Error de sintaxis: %s en línea %d\n", msg,yylineno);
    fprintf(stderr, "El parser no espera '%s'\n",yytext);
    return 0;
}

TreeNode* makeNode(char* token, TreeNode* left, TreeNode* right){
    TreeNode* new_node = (TreeNode*)malloc(sizeof(TreeNode));
    if (new_node == NULL) { perror("Error de asignación de memoria para el nodo AST"); exit(1); }
    new_node->data = strdup(token);
    new_node->left = left;
    new_node->right = right;
    return new_node;
}

void print_preorder(TreeNode* tree,int indent){
    int i;
    if (tree)
    {
        for(i = 0; i < indent; i++){ printf("|  "); }
        printf("-> %s\n",tree->data);
        print_preorder(tree->left, indent+1);
        print_preorder(tree->right, indent+1);
    }
}

void delTree(TreeNode* tree){
    if (tree)
    {
        delTree(tree->left);
        delTree(tree->right);
        free(tree->data); 
        free(tree);
    }
}