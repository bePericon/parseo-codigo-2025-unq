
#include "interpreter.h"
#include "symtab.h"
#include "ast.h"
#include "parser.tab.h"

Value evaluate_ast(AST *node, Environment *current_env) {

}

int main(void) {
    int result = yyparse();
    if (result == 0) {
        AST *root = ast_get_root();
        ast_print(root, 0);
        printf("\n\n=== AST final ===\n");

        Environment *env_current = env_create(NULL);
        env_add_variable(env_current, "x", (Value){.type = INT_T, .value.int_val = 5});
        env_add_variable(env_current, "y", (Value){.type = INT_T, .value.int_val = 3});
        env_add_variable(env_current, "z", (Value){.type = INT_T, .value.int_val = 2});

        env_print(env_current);

        env_lookup_variable(env_current, "x"); // exist
        env_lookup_variable(env_current, "w"); // not found

        env_update_variable(env_current, "y", (Value){.type = INT_T, .value.int_val = 10});

        env_print(env_current);
    }
    return result;
}