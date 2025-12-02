#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

typedef enum { INT_T, BOOL_T, STR_T, OBJ_T, VOID_T } ValueType;

typedef struct Function {
    char *name;
    AST *params;
    AST *body;
    struct Function *next;
} Function;

typedef struct Class {
    char *name;
    Function *features;
    struct Class *next;
} Class;

typedef struct Object {
    Class *class_def;
    struct Environment *attributes;
} Object;

typedef struct {
    ValueType type;
    union {
        int int_val;       
        int bool_val;      
        char* str_val;
        Object* obj_val;
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
char* type_string(ValueType type);

Environment* env_create(Environment* parent);
void env_free(Environment* env);
void env_add_variable(Environment* env, const char* name, Value value);
Value* env_lookup_variable(Environment* env, const char* name);
void env_update_variable(Environment* env, const char* name, Value new_value);


void print_features(Function* functions);
void global_classes_print(Class* gcls);
Class* classes_create(Class* parent);
void register_class(Class* parent, const char *name, AST *feature_list);
Class* lookup_class(Class* cls, const char *name);
Function* lookup_feature(Class* cls, const char *feature_name);

#endif