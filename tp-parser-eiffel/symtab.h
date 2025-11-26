#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>
#include <stdlib.h>

typedef enum { INT_T, BOOL_T, CHAR_T, STR_T } ValueType;

typedef struct {
    ValueType type;
    union {
        int int_val;       
        int bool_val;      
        char char_val;     
        char* str_val;     
    } value;
} Value;

typedef struct Map {
    char* key;
    Value value;
    struct Map* next;
} Map;


typedef struct Environment {
    Map* variables;
    struct Environment* parent;
} Environment;

void env_print(Environment* env);

void print_value(Value value);
Environment* env_create(Environment* parent);
void env_free(Environment* env);
void env_add_variable(Environment* env, const char* name, Value value);
Value* env_lookup_variable(Environment* env, const char* name);
void env_update_variable(Environment* env, const char* name, Value new_value);

#endif