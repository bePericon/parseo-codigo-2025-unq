#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ast.h"
#include "symtab.h"
#include "parser.tab.h"
#include "runtime.h"
extern int yylineno;
extern AST *root;

void scan_definitions(AST *node, Class* global_cls) {
    if (!node) return;

    if (node->kind == N_CLASS) {
        Class *cls = (Class*)calloc(1, sizeof(Class));
        cls->name = strdup(node->name);
        cls->next = global_cls; 
        global_cls = cls; 

        AST *feat_seq = node->left;

        extract_features_from_ast(cls, feat_seq); 
        
        return;
    }

    scan_definitions(node->left);
    scan_definitions(node->right);
}

static void declare_var_list(AST *list_node, Environment *env) {
    if (!list_node) return;

    if (list_node->kind == N_SEQ) {
        declare_var_list(list_node->left, env);
        declare_var_list(list_node->right, env);

    } else if (list_node->kind == N_VAR) {
        const char *var_name = list_node->value.sval;
        
        if (env_lookup_variable(env, var_name) != NULL) {
             fprintf(stderr, "\n Runtime/Semantic error: The variable '%s' is already declared in this scope (line %d)\n", var_name, yylineno);
             exit(1);
        }
        
        Value initial_val = (Value){ .type = INT_T, .value.int_val = 0 };

        env_add_variable(env, var_name, initial_val);

    } else {
        fprintf(stderr, "\n Runtime/Semantic error: N_VARDECL found an unexpected node of type %d in the list\n", list_node->kind);
        exit(1);
    }
}

Value evaluate_ast(AST *node, Environment *env, Class *global_cls) {
    Value result = { .type = INT_T, .value.int_val = 0 };
    if (!node) return result;

    switch (node->kind) {

        case N_CLASS: {
            scan_definitions(node->left, global_cls);
            if (node->right)
                scan_definitions(node->right, global_cls);
        }
        case N_PROGRAM:
        case N_FEATURE:
        case N_BLOCK:
        case N_SEQ: {
            evaluate_ast(node->left, env);
            if (node->right)
                evaluate_ast(node->right, env);
            Value v;
            v.type = INT_T;
            v.value.int_val = 0;
            return v;
        }

        case N_VARDECL: {
            declare_var_list(node->left, env);
            
            Value v = { .type = INT_T, .value.int_val = 0 };
            return v;
        }


        case N_ASSIGN: {
            Value val = evaluate_ast(node->right, env);
            Value *existing = env_lookup_variable(env, node->left->value.sval);
            if (existing)
                env_update_variable(env, node->left->value.sval, val);
            else{
                fprintf(stderr, "\n Runtime/Semantic error: variable '%s' not declared (line %d)\n", node->left->value.sval, yylineno);
                exit(1);
                // env_add_variable(env, node->left->value.sval, val);
            }

            result = val;
            return val;
        }

        case N_VAR: {
            Value *pv = env_lookup_variable(env, node->value.sval);
            if (pv) {
                return *pv;
            } else {
                fprintf(stderr, "\n Runtime/Semantic error: variable '%s' not found (line %d)\n", node->value.sval, yylineno);
                exit(1);
            }
        }

        case N_BINOP: {
            Value l = evaluate_ast(node->left, env);
            Value r = evaluate_ast(node->right, env);
            result.type = INT_T;

            if (strcmp(node->name, "+") == 0){
                if(l.type == INT_T && r.type == INT_T){
                    result.value.int_val = l.value.int_val + r.value.int_val;
                }else if (l.type == STR_T && r.type == STR_T){
                    int str_len_l = strlen(l.value.str_val) > 1? strlen(l.value.str_val)-1 : 0;
                    int str_len_r = strlen(r.value.str_val) > 1? strlen(r.value.str_val)-1 : 0;
                    int str_len = str_len_l + str_len_r;
                    char *str = (char *)malloc(str_len + 1);

                    strncpy(str, l.value.str_val, str_len_l);
                    strncat(str, r.value.str_val +1, str_len_r);

                    result.type = STR_T;
                    result.value.str_val = str;
                }else{
                    throw_error_types(l.type, r.type);
                }
            }
            else if (strcmp(node->name, "-") == 0)
                result.value.int_val = l.value.int_val - r.value.int_val;
            else if (strcmp(node->name, "*") == 0)
                result.value.int_val = l.value.int_val * r.value.int_val;
            else if (strcmp(node->name, "/") == 0)
                result.value.int_val = r.value.int_val ? l.value.int_val / r.value.int_val : 0;
            else if (strcmp(node->name, "=") == 0){
                if(l.type == INT_T && r.type == INT_T) {
                    result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val == r.value.int_val) };
                }else if (l.type == BOOL_T && r.type == BOOL_T){
                    result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.bool_val == r.value.bool_val) };
                }else{
                    throw_error_types(l.type, r.type);
                }
            }
            else if (strcmp(node->name, "/=") == 0)
                if(l.type == INT_T && r.type == INT_T) {
                    result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.int_val != r.value.int_val) };
                }else if (l.type == BOOL_T && r.type == BOOL_T){
                    result = (Value){ .type = BOOL_T, .value.bool_val = (l.value.bool_val != r.value.bool_val) };
                }else{
                    throw_error_types(l.type, r.type);
                }
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
            result.value.bool_val = node->value.bval;
            break;

        case N_STRING:
            result.type = STR_T;
            result.value.str_val = strdup(node->value.sval);
            break;

        case N_PRINT: {
            Value val = evaluate_ast(node->left, env);
            printf("print(value) => { ");
            print_value(val);
            printf(" }\n");
            return val;
        }

        case N_IF_BLOCK: {
            AST *ifNode = node->left;
            AST *elseNode = node->right;

            AST *condNode = ifNode->left;
            Value condVal = evaluate_ast(condNode->left, env);

            if (condVal.value.int_val != 0 || condVal.value.bool_val) {
                evaluate_ast(ifNode->right, env);
            } else if (elseNode) {
                evaluate_ast(elseNode->left, env);
            }

            return condVal;
        }


        case N_LOOP: {
            AST *initNode = node->left;
            AST *untilNode = node->right;
            AST *condNode = untilNode->left;
            AST *bodyNode = untilNode->right;

            evaluate_ast(initNode, env);

            while (1) {
                Value condVal = evaluate_ast(condNode->left, env);
                if (condVal.value.int_val != 0 || condVal.value.bool_val) break;
                evaluate_ast(bodyNode->left, env);
            }

            Value v;
            v.type = INT_T;
            v.value.int_val = 0;
            return v;
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
        Class *global_classes = classes_create(NULL);
        evaluate_ast(root, global_env);

        
        
        printf("\n=== Estado final del entorno ===\n");
        env_print(global_env);
        env_free(global_env);

        printf("\n=== Estado final del GLOBAL CLASSES ===\n");
        global_classes_print(global_classes);
        // global_classes_free(global_classes);

    } /* else {
        fprintf(stderr, " Error de análisis sintáctico en la línea %d.\n", yylineno);
    } */
    return 0;
}
