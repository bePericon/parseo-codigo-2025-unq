#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ast.h"
#include "symtab.h"
#include "parser.tab.h"
extern int yylineno;
extern AST *root;



Value evaluate_ast(AST *node, Environment *env) {
    Value result = { .type = INT_T, .value.int_val = 0 };
    if (!node) return result;

    switch (node->kind) {

        case N_PROGRAM:
        case N_CLASS:
        case N_FEATURE:
        case N_BLOCK:
        case N_SEQ:
            evaluate_ast(node->left, env);
            evaluate_ast(node->right, env);
            break;

        case N_ASSIGN: {
            Value val = evaluate_ast(node->right, env);
            Value *existing = env_lookup_variable(env, node->left->value.sval);
            if (existing)
                env_update_variable(env, node->left->value.sval, val);
            else
                env_add_variable(env, node->left->value.sval, val);
            result = val;
            return val;
        }

        case N_VAR: {
            Value *pv = env_lookup_variable(env, node->value.sval);
            if (pv) {
                return *pv;
            } else {
                fprintf(stderr, "No se pudo encontrar la variable '%s' en el environment.\n", node->value.sval);
                Value v;
                v.type = INT_T;
                v.value.int_val = 0;
                return v;
            }
        }

        case N_BINOP: {
            Value l = evaluate_ast(node->left, env);
            Value r = evaluate_ast(node->right, env);
            result.type = INT_T;

            if (strcmp(node->name, "+") == 0)
                result.value.int_val = l.value.int_val + r.value.int_val;
            else if (strcmp(node->name, "-") == 0)
                result.value.int_val = l.value.int_val - r.value.int_val;
            else if (strcmp(node->name, "*") == 0)
                result.value.int_val = l.value.int_val * r.value.int_val;
            else if (strcmp(node->name, "/") == 0)
                result.value.int_val = r.value.int_val ? l.value.int_val / r.value.int_val : 0;
            else if (strcmp(node->name, "=") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val == r.value.int_val) };
            else if (strcmp(node->name, "<") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val < r.value.int_val) };
            else if (strcmp(node->name, ">") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val > r.value.int_val) };
            else if (strcmp(node->name, "<=") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val <= r.value.int_val) };
            else if (strcmp(node->name, ">=") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val >= r.value.int_val) };
            else if (strcmp(node->name, "AND") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.bool_val && r.value.bool_val) };
            else if (strcmp(node->name, "OR") == 0)
                result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.bool_val || r.value.bool_val) };
            return result;
        }

        case N_UNARYOP:
            if (strcmp(node->name, "NOT") == 0) {
                Value v = evaluate_ast(node->left, env);
                result.type = BOOL_T;
                result.value.bool_val = !v.value.bool_val;
            }
            break;

        case N_INT:
            result.type = INT_T;
            result.value.int_val =  node->value.ival;
            break;

        case N_BOOL:
            result.type = BOOL_T;
            result.value.bool_val = (strcmp(node->name, "true") == 0);
            break;

        case N_STRING:
            result.type = STR_T;
            result.value.str_val = strdup(node->name);
            break;

        case N_PRINT: {
            Value val = evaluate_ast(node->left, env);
            print_value(val);
            printf("\n");
            return val;
        }

        case N_IF_BLOCK: {
            Value cond = evaluate_ast(node->left->left, env);
            if (cond.value.bool_val)
                evaluate_ast(node->left->right, env);
            else
                evaluate_ast(node->right, env); 
            break;
        }

        case N_LOOP: {
            evaluate_ast(node->left, env); 
            AST *until_node = node->right; 
            AST *cond = until_node->left;  
            AST *body = until_node->right;

            while (!evaluate_ast(cond, env).value.bool_val)
                evaluate_ast(body, env);
            break;
        }

        default:
            break;
    }

    return result;
}


int main(void) {
    extern AST *root; 
    extern int yyparse();
    extern int yylineno;

    printf("=== Análisis lexico y sintactico ===\n");
    if (yyparse() == 0) {
        printf("Análisis sintáctico exitoso.\n");

        printf("\n=== AST ===\n");
        ast_print(root, 0);

        printf("\n=== Ejecucion ===\n");
        Environment *global_env = env_create(NULL);
        evaluate_ast(root, global_env);

        printf("\n=== Estado final del entorno ===\n");
        env_print(global_env);
        env_free(global_env);
    } else {
        fprintf(stderr, " Error de análisis sintáctico en la línea %d.\n", yylineno);
    }
    return 0;
}
