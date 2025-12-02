#include <string.h>
#include "symtab.h"

extern int yylineno;

void print_value(Value v) {
    switch (v.type) {
        case INT_T:
            printf("Tipo: INT, Valor: %d", v.value.int_val);
            break;
        case BOOL_T:
            printf("Tipo: BOOL, Valor: %s", v.value.bool_val ? "true" : "false");
            break;
        case CHAR_T:
            printf("Tipo: CHAR, Valor: '%c'", v.value.char_val);
            break;
        case STR_T:
            printf("Tipo: STR, Valor: %s", v.value.str_val);
            break;
        default:
            printf("Tipo: DESCONOCIDO");
            break;
    }
}

char* type_string(ValueType type) {
    switch (type) {
        case INT_T:
            return "INTEGER";
        case BOOL_T:
            return "BOOLEAN";
        case CHAR_T:
            return "CHAR";
        case STR_T:
            return "STRING";
        default:
            return "DESCONOCIDO";
    }
}

void env_print(Environment* env) {
    int env_level = 0;
    Environment* current_env = env;

    while (current_env != NULL) {
        printf("\n=== ENTORNO #%d (%s) ===\n", env_level, (current_env == env) ? "Local" : "Padre");
        
        Map* current_map = current_env->variables;
        
        if (current_map == NULL) {
            printf("  (Este entorno está vacío)\n");
        } else {
            while (current_map != NULL) {
                printf("  Clave: %s -> { ", current_map->key);
                print_value(current_map->value);
                printf(" }\n");
                current_map = current_map->next;
            }
        }
        
        current_env = current_env->parent;
        env_level++;
    }

    printf("=========================\n");
}

Environment* env_create(Environment* parent) {
    Environment* env = (Environment*)malloc(sizeof(Environment));
    if (!env) {
        perror("Error de asignación de memoria para Environment");
        exit(EXIT_FAILURE);
    }

    env->variables = NULL;
    env->parent = parent;
    return env;
}

void env_free(Environment* env) {
    if(!env) return;

    Map* current = env->variables;
    while (current) {
        Map* next = current->next;
        free(current->key);
        free(current);
        current = next;
    }

    free(env);
}

void env_add_variable(Environment* env, const char* name, Value value) {
    Map* current = env->variables;
    while (current != NULL) {
        if (strcmp(current->key, name) == 0) {
            // fprintf(stderr, "Advertencia: La variable '%s' ya existe en este environment.\n", name);
            current->value = value;
            return;
        }
        current = current->next;
    }

    Map* new_map = (Map*)malloc(sizeof(Map));
    if (!new_map) {
        perror("Error de asignación de memoria para Map");
        exit(EXIT_FAILURE);
    }

    new_map->key = strdup(name);
    new_map->value = value;
    new_map->next = env->variables;
    env->variables = new_map;
}

Value* env_lookup_variable(Environment* env, const char* name) {
    Value* found_var = NULL;
    Environment* current_env = env;
    Map* current = current_env->variables;

    while (current != NULL) {
        if (strcmp(current->key, name) == 0) {
            found_var = &(current->value);

            // fprintf(stderr, "Se encontró la variable '%s' en el environment => { ", name);
            // print_value(*found_var);
            // printf(" }\n");

            return found_var;
        }
        current = current->next;
    }

    if(current_env->parent == NULL) {
        // fprintf(stderr, "No se pudo encontrar la variable '%s' en el environment.\n", name);
        return NULL;
    }

    return env_lookup_variable(current_env->parent, name);
}

void env_update_variable(Environment* env, const char* name, Value new_value) {
    Value* found_var = NULL;
    Environment* current_env = env;
    Map* current = current_env->variables;

    while (current != NULL) {
        if (strcmp(current->key, name) == 0) {
            found_var = &(current->value);

            if(new_value.type != found_var->type){
                fprintf(stderr, "\n Runtime/Semantic error: '%s' variable cannot be assigned as an '%s' (line %d)\n", 
                    type_string(found_var->type), type_string(new_value.type), yylineno);
                exit(1);
            }

            // fprintf(stderr, "Se actualizó la variable '%s' en el environment => { ", name);
            // print_value(*found_var);
            // printf(" } => { ");
            // print_value(new_value);
            // printf(" }\n");
            
            current->value = new_value;
            return;
        }
        current = current->next;
    }

    if(current_env->parent == NULL) {
        // fprintf(stderr, "No se pudo actualizar la variable '%s' en el environment.\n", name);
        return;
    }

    return env_update_variable(current_env->parent, name, new_value);
}