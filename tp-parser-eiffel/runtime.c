#include "runtime.h"

#include "symtab.h"
extern int yylineno;

void throw_error_types(ValueType type1, ValueType type2) {
    fprintf(stderr, "\n Runtime/Semantic error: operator '+' cannot be used between types %s and %s (line %d)\n", 
                type_string(type1), type_string(type2), yylineno);
    exit(1);
}
