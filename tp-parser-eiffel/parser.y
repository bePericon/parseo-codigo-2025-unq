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
extern int yycolumn;
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

%type <TreeNode> PROGRAM CLASS_DEF FEATURE_LIST FEATURE_DEF BLOCK STATEMENT_LIST STATEMENT EXPR TERM FACTOR

%left EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT_EQUAL
%left AND OR
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT  /* negación unaria */

%%

PROGRAM
    : CLASS_DEF                           { print_preorder($1, 0); }
    ;

CLASS_DEF
    : CLASS IDENTIFIER FEATURE_LIST END   {
        TreeNode* cname = makeNode($2, NULL, NULL);
        $$ = makeNode("CLASS_DEF", cname, $3);
    }
    ;

FEATURE_LIST
    : FEATURE_DEF FEATURE_LIST            { $$ = makeNode("FEATURE_LIST", $1, $2); }
    | FEATURE_DEF                         { $$ = $1; }
    ;

FEATURE_DEF
    : FEATURE IDENTIFIER BLOCK            {
        TreeNode* fname = makeNode($2, NULL, NULL);
        $$ = makeNode("FEATURE_DEF", fname, $3);
    }
    ;

BLOCK
    : DO STATEMENT_LIST END               { $$ = makeNode("BLOCK", NULL, $2); }
    ;

STATEMENT_LIST
    : STATEMENT STATEMENT_LIST            { $$ = makeNode("STATEMENT_LIST", $1, $2); }
    | STATEMENT                           { $$ = $1; }
    ;

STATEMENT
    : IDENTIFIER ASSIGN EXPR              { 
        TreeNode* id = makeNode($1, NULL, NULL);
        $$ = makeNode("ASSIGN", id, $3);
    }
    | PRINT PARENTHESIS_OPEN EXPR PARENTHESIS_CLOSE { 
        $$ = makeNode("PRINT", $3, NULL);
    }
    | IF EXPR THEN STATEMENT_LIST ELSE STATEMENT_LIST END {
        TreeNode* cond = makeNode("COND", $2, NULL);
        TreeNode* thenb = makeNode("THEN", $4, NULL);
        TreeNode* elseb = makeNode("ELSE", $6, NULL);
        TreeNode* temp = makeNode("IF", cond, thenb);
        $$ = makeNode("IF_BLOCK", temp, elseb);
    }
    | FROM STATEMENT_LIST UNTIL EXPR LOOP STATEMENT_LIST END {
        TreeNode* init = makeNode("INIT", $2, NULL);
        TreeNode* cond = makeNode("COND", $4, NULL);
        TreeNode* body = makeNode("BODY", $6, NULL);
        $$ = makeNode("LOOP_BLOCK", init, makeNode("UNTIL", cond, body));
    }
    ;

EXPR
    : EXPR PLUS TERM                      { $$ = makeNode("+", $1, $3); }
    | EXPR MINUS TERM                     { $$ = makeNode("-", $1, $3); }
    | EXPR EQUAL TERM                     { $$ = makeNode("=", $1, $3); }
    | EXPR NOT_EQUAL TERM                 { $$ = makeNode("/=", $1, $3); }
    | EXPR LESS TERM                      { $$ = makeNode("<", $1, $3); }
    | EXPR GREATER TERM                   { $$ = makeNode(">", $1, $3); }
    | EXPR LESS_EQUAL TERM                { $$ = makeNode("<=", $1, $3); }
    | EXPR GREATER_EQUAL TERM             { $$ = makeNode(">=", $1, $3); }
    | EXPR AND TERM                       { $$ = makeNode("AND", $1, $3); }
    | EXPR OR TERM                        { $$ = makeNode("OR", $1, $3); }
    | TERM                                { $$ = $1; }
    ;

TERM
    : TERM TIMES FACTOR                   { $$ = makeNode("*", $1, $3); }
    | TERM DIVIDE FACTOR                  { $$ = makeNode("/", $1, $3); }
    | FACTOR                              { $$ = $1; }
    ;

FACTOR
    : NUMBER                              { $$ = makeNode($1, NULL, NULL); }
    | STRING                              { $$ = makeNode($1, NULL, NULL); }
    | REAL                                { $$ = makeNode($1, NULL, NULL); }
    | TRUE                                { $$ = makeNode("True", NULL, NULL); }
    | FALSE                               { $$ = makeNode("False", NULL, NULL); }
    | IDENTIFIER                          { $$ = makeNode($1, NULL, NULL); }
    | PARENTHESIS_OPEN EXPR PARENTHESIS_CLOSE { $$ = $2; }
    | NOT FACTOR                          { $$ = makeNode("NOT", $2, NULL); }
    ;

%%

int main(void) {
    return yyparse();
}

int yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "\n Error de sintaxis: %s\n", msg);
    fprintf(stderr, "   Línea: %d, Columna: %d\n", yylineno, yycolumn);
    fprintf(stderr, "Token inesperado: '%s'\n", yytext);
    return 1;
}

TreeNode* makeNode(char* token, TreeNode* left, TreeNode* right){
    TreeNode* n = (TreeNode*)malloc(sizeof(TreeNode));
    if(!n){ perror("malloc"); exit(1); }
    n->data = strdup(token);
    n->left = left;
    n->right = right;
    return n;
}

void print_preorder(TreeNode* t, int indent){
    if(!t) return;
    for(int i=0;i<indent;i++) printf("|  ");
    printf("-> %s\n", t->data);
    print_preorder(t->left, indent+1);
    print_preorder(t->right, indent+1);
}

void delTree(TreeNode* t){
    if(!t) return;
    delTree(t->left);
    delTree(t->right);
    free(t->data);
    free(t);
}
