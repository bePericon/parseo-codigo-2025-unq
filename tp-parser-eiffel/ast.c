#include "ast.h"
#include <string.h>

static AST *root = NULL;

AST *ast_new_node(NodeKind kind, const char *name, AST *left, AST *right) {
    AST *n = (AST *)calloc(1, sizeof(AST));
    if (!n) { perror("malloc"); exit(1); }
    n->kind = kind;
    n->name = name ? strdup(name) : NULL;
    n->left = left;
    n->right = right;
    n->value.ival = 0;
    n->value.rval = 0.0;
    n->value.bval = 0;
    n->value.sval = NULL;
    return n;
}

// Constructores
AST *ast_new_int(long v) {
    AST *n = ast_new_node(N_INT, "INT", NULL, NULL);
    n->value.ival = v;
    return n;
}

AST *ast_new_real(double d) {
    AST *n = ast_new_node(N_REAL, "REAL", NULL, NULL);
    n->value.rval = d;
    return n;
}

AST *ast_new_string(const char *s) {
    AST *n = ast_new_node(N_STRING, "STRING", NULL, NULL);
    n->value.sval = strdup(s);
    return n;
}

AST *ast_new_bool(int b) {
    AST *n = ast_new_node(N_BOOL, "BOOL", NULL, NULL);
    n->value.bval = b;
    return n;
}

AST *ast_new_var(const char *name) {
    AST *n = ast_new_node(N_VAR, "VAR", NULL, NULL);
    n->value.sval = strdup(name ? name : "");
    return n;
    return n;
}

// Liberación recursiva
void ast_free(AST *a) {
    if (!a) return;
    ast_free(a->left);
    ast_free(a->right);
    if (a->name) free(a->name);
    if (a->kind == N_STRING || a->kind == N_VAR) free(a->value.sval);
    free(a);
}

static void ast_print_rec(AST *a, int indent) {
    if (!a) return;
    for (int i = 0; i < indent; i++) printf("  ");

    switch (a->kind) {
        case N_PROGRAM:      printf("-> PROGRAM\n"); break;
        case N_CLASS:        printf("-> CLASS %s\n", a->value.sval ? a->value.sval : ""); break;
        case N_FEATURE:      printf("-> FEATURE\n"); break;
        case N_BLOCK:        printf("-> BLOCK\n"); break;
        case N_VARDECL:      printf("-> VAR DECL\n"); break;
        case N_SEQ:          printf("-> SEQUENCE\n"); break;
        case N_INT:          printf("-> INT: %ld\n", a->value.ival); break;
        case N_REAL:         printf("-> REAL: %g\n", a->value.rval); break;
        case N_STRING:       printf("-> STRING: %s\n", a->value.sval); break;
        case N_BOOL:         printf("-> BOOL: %s\n", a->value.bval ? "true" : "false"); break;
        case N_VAR:          printf("-> VAR: %s\n", a->value.sval); break;
        case N_ASSIGN:       printf("-> ASSIGN (%s)\n", a->name ? a->name : ":="); break;
        case N_BINOP:        printf("-> BINOP (%s)\n", a->name ? a->name : "?"); break;
        case N_UNARYOP:      printf("-> UNARYOP (%s)\n", a->name ? a->name : "?"); break;
        case N_IF:           printf("-> IF\n"); break;
        case N_IF_BLOCK:     printf("-> IF_BLOCK\n"); break;
        case N_COND:         printf("-> COND\n"); break;
        case N_LOOP:         printf("-> LOOP_BLOCK\n"); break;
        case N_INIT:         printf("-> INIT\n"); break;
        case N_BODY:         printf("-> BODY\n"); break;
        case N_UNTIL:        printf("-> UNTIL\n"); break;
        case N_PRINT:        printf("-> PRINT\n"); break;
        case N_NOOP:         printf("-> NOOP\n"); break;
        default:             printf("-> UNKNOWN NODE\n"); break;
    }

    ast_print_rec(a->left, indent + 1);
    ast_print_rec(a->right, indent + 1);
}

void ast_print(AST *a, int indent) {
    printf("\n=== AST ===\n");
    ast_print_rec(a, indent);
    printf("===========\n");
}

void ast_set_root(AST *r) { root = r; }
AST *ast_get_root(void) { return root; }
