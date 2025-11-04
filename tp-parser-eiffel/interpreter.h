#ifndef INTERPRETER_H
#define INTERPRETER_H

#include "ast.h"
#include "symtab.h"

Value evaluate_ast(AST *node, Environment *current_env);

#endif