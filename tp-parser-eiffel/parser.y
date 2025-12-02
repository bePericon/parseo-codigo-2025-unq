%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"  

extern int yylex();
extern int yylineno;
extern int yycolumn;
extern char *yytext;

AST *root = NULL;

int yyerror(const char *msg);
%}

%union {
    char *str;
    struct AST* ast;
}

%token <str> CLASS LOCAL FEATURE DO END 
%token <str> IF THEN ELSE FROM UNTIL LOOP PRINT
%token <str> IDENTIFIER RESERVED_TYPE NUMBER STRING REAL TRUE FALSE
%token <str> PLUS MINUS TIMES DIVIDE ASSIGN EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%token <str> NOT NOT_EQUAL AND OR
%token <str> PARENTHESIS_OPEN PARENTHESIS_CLOSE COLON COMMA
%token <str> UNKNOWN

%type <ast> PROGRAM CLASS_DEF FEATURE_LIST FEATURE_DEF BLOCK STATEMENT_LIST STATEMENT EXPR FACTOR 
%type <ast> VAR_DECL VAR_DECL_LIST LOCAL_DECL MULT_ID ID

%left OR
%left AND
%left EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL NOT_EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT  /* negación unaria */

%%

PROGRAM
    : CLASS_DEF { 
        root = $1;
        printf("\n Árbol sintáctico construido con éxito.\n\n");
    }
    ;

CLASS_DEF
    : CLASS IDENTIFIER FEATURE_LIST END {
        $$ = ast_new_node(N_CLASS, (char*)$2, $3, NULL);
    }
    ;

FEATURE_LIST
    : FEATURE_DEF FEATURE_LIST  { $$ = ast_new_node(N_SEQ, "FEATURE_LIST", $1, $2); }
    | FEATURE_DEF               { $$ = $1; }
    ;

FEATURE_DEF
    : FEATURE IDENTIFIER BLOCK {
        $$ = ast_new_node(N_FEATURE, (char*)$2,$3,NULL);
    }
    ;

BLOCK
    : LOCAL_DECL DO STATEMENT_LIST END { $$ = ast_new_node(N_BLOCK, "BLOCK", $1, $3); }
    | DO STATEMENT_LIST END            { $$ = ast_new_node(N_BLOCK, "BLOCK", NULL, $2); }
    ;

LOCAL_DECL
    : LOCAL VAR_DECL_LIST { $$ = $2; }
    ;

VAR_DECL_LIST
    : VAR_DECL VAR_DECL_LIST { $$ = ast_new_node(N_SEQ, "VAR_DECL_LIST", $1, $2); }
    | VAR_DECL               { $$ = $1; }
    ;

VAR_DECL
    : MULT_ID COLON RESERVED_TYPE {
        AST *type = ast_new_var($3);
        $$ = ast_new_node(N_VARDECL, "VAR_DECL", $1, type);
    }
    ;

MULT_ID
    : MULT_ID COMMA ID   { $$ = ast_new_node(N_SEQ, "MULT_ID", $1, $3); }
    | ID                 { $$ = $1; } 
    ;

STATEMENT_LIST
    : STATEMENT STATEMENT_LIST  { $$ = ast_new_node(N_SEQ, "STATEMENT_LIST", $1, $2); }
    | STATEMENT                 { $$ = $1; }
    ;

STATEMENT
    : IDENTIFIER ASSIGN EXPR {
        AST *var = ast_new_var($1);
        $$ = ast_new_node(N_ASSIGN, ":=", var, $3);
    }
    | PRINT PARENTHESIS_OPEN EXPR PARENTHESIS_CLOSE { 
        $$ = ast_new_node(N_PRINT, "PRINT", $3, NULL);
    }
    | IF EXPR THEN STATEMENT_LIST ELSE STATEMENT_LIST END {
        AST *cond = ast_new_node(N_COND, "COND", $2, NULL);
        AST *thenb = ast_new_node(N_SEQ, "THEN", $4, NULL);
        AST *elseb = ast_new_node(N_SEQ, "ELSE", $6, NULL);
        AST *temp = ast_new_node(N_IF, "IF", cond, thenb);
        $$ = ast_new_node(N_IF_BLOCK, "IF_BLOCK", temp, elseb);
    }
    | FROM STATEMENT_LIST UNTIL EXPR LOOP STATEMENT_LIST END {
        AST *init = ast_new_node(N_INIT, "INIT", $2, NULL);
        AST *cond = ast_new_node(N_COND, "COND", $4, NULL);
        AST *body = ast_new_node(N_BODY, "BODY", $6, NULL);
        $$ = ast_new_node(N_LOOP, "LOOP_BLOCK", init, ast_new_node(N_UNTIL, "UNTIL", cond, body));
    }
    ;

EXPR
    : EXPR PLUS EXPR          { $$ = ast_new_node(N_BINOP, "+", $1, $3); }
    | EXPR MINUS EXPR         { $$ = ast_new_node(N_BINOP, "-", $1, $3); }
    | EXPR TIMES EXPR         { $$ = ast_new_node(N_BINOP, "*", $1, $3); }
    | EXPR DIVIDE EXPR        { $$ = ast_new_node(N_BINOP, "/", $1, $3); }
    | EXPR EQUAL EXPR         { $$ = ast_new_node(N_BINOP, "=", $1, $3); }
    | EXPR NOT_EQUAL EXPR     { $$ = ast_new_node(N_BINOP, "/=", $1, $3); }
    | EXPR LESS EXPR          { $$ = ast_new_node(N_BINOP, "<", $1, $3); }
    | EXPR GREATER EXPR       { $$ = ast_new_node(N_BINOP, ">", $1, $3); }
    | EXPR LESS_EQUAL EXPR    { $$ = ast_new_node(N_BINOP, "<=", $1, $3); }
    | EXPR GREATER_EQUAL EXPR { $$ = ast_new_node(N_BINOP, ">=", $1, $3); }
    | EXPR AND EXPR           { $$ = ast_new_node(N_BINOP, "AND", $1, $3); }
    | EXPR OR EXPR            { $$ = ast_new_node(N_BINOP, "OR", $1, $3); }
    | NOT EXPR                { $$ = ast_new_node(N_UNARYOP, "NOT", $2, NULL); }
    | FACTOR                  { $$ = $1; }
    ;

FACTOR
    : NUMBER  { $$ = ast_new_int(atol($1)); }
    | STRING  { $$ = ast_new_string($1); }
    | REAL    { $$ = ast_new_real(atof($1)); }
    | TRUE    { $$ = ast_new_bool(1); }
    | FALSE   { $$ = ast_new_bool(0); }
    | ID      { $$ = $1; }
    | PARENTHESIS_OPEN EXPR PARENTHESIS_CLOSE { $$ = $2; }
    ;

ID
    : IDENTIFIER { $$ = ast_new_var($1); }
    ;

%%

/* int main(void) {
    int result = yyparse();
    if (result == 0) {
        AST *root = ast_get_root();
        ast_print(root, 0);
        printf("\n\n=== AST final ===\n");
    }
    return result;
} */

int yyerror(const char *msg) {
    fflush(stdout);
    fprintf(stderr, "\n Syntax error: unexpected token '%s' (line %d, column %d)\n", yytext, yylineno, yycolumn);
    return 1;
}
