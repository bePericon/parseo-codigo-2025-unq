#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>

typedef enum {
    N_PROGRAM,
    N_CLASS,
    N_FEATURE,
    N_BLOCK,
    N_VARDECL,
    N_SEQ,
    N_INT,
    N_REAL,
    N_STRING,
    N_BOOL,
    N_VAR,
    N_ASSIGN,
    N_BINOP,
    N_UNARYOP,
    N_IF,
    N_IF_BLOCK,
    N_COND,
    N_LOOP,
    N_INIT,
    N_BODY,
    N_UNTIL,
    N_PRINT,
    N_NOOP,

    N_METADATA,
    N_FEATURE_FUNC,
    N_CALL,
    N_DOT_ACCESS,
    N_CREATE,
} NodeKind;

typedef struct AST {
    NodeKind kind;
    char *name;
    struct AST *left;
    struct AST *right;
    union {
        long ival;
        double rval;
        char *sval;
        int bval;
    } value;
} AST;

AST *ast_new_node(NodeKind kind, const char *name, AST *left, AST *right);
AST *ast_new_int(long v);
AST *ast_new_real(double d);
AST *ast_new_string(const char *s);
AST *ast_new_bool(int b);
AST *ast_new_var(const char *name);

void ast_print(AST *a, int indent);
void ast_free(AST *a);

void ast_set_root(AST *r);
AST *ast_get_root(void);

#endif
