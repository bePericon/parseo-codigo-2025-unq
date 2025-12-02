#include <string.h>
#include "symtab.h"

void print_value(Value v) {
    switch (v.type) {
        case INT_T:
            printf("Tipo: INT, Valor: %d", v.value.int_val);
            break;
        case BOOL_T:
            printf("Tipo: BOOL, Valor: %s", v.value.bool_val ? "true" : "false");
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

    printf("==========================\n");
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


/* ########### CLASSES MANAGEMENT ########### */ 

void print_features(Function* functions) {
    Function* current = functions;
    printf("\n Features: [\n");
    while (current != NULL) {
        printf(" %s, \n", current->name);
        current = current->next;
    }
    printf("]\n");
}

void global_classes_print(Class* gcls) {
    int cls_level = 0;
    Class* current = gcls;

    while (current != NULL) {
        printf("\n=== GLOBAL CLASSES #%d (%s) ===\n", cls_level, (current == gcls) ? "Local" : "Padre");
        
        Function* current_features = current->features;
        
        if (current_features == NULL) {
            printf("  (Esta clase está vacía)\n");
        } else {
            while (current_features != NULL) {
                printf("  Nombre: %s -> { ", current_features->name);
                print_features(current_features);
                printf(" }\n");
                current_features = current_features->next;
            }
        }
        
        current = current->next;
        cls_level++;
    }

    printf("=================================\n");
}

#define CLASS_NAME "GLOBAL_CLASSES"

Class* classes_create(Class* parent) {
    Class* class = (Class*)malloc(sizeof(Class));
    if (!class) {
        perror("Error de asignación de memoria para GLOBAL_CLASSES");
        exit(EXIT_FAILURE);
    }

    class->features = NULL;
    class->name = CLASS_NAME;
    class->next = NULL;
    return class;
}

void register_class(Class* parent, const char *name, AST *feature_list) {
    Class *new_class = (Class*)malloc(sizeof(Class));
    new_class->name = strdup(name);
    new_class->features = NULL;
    new_class->next = parent;

    AST *current = feature_list;


    // new_class->features = current;
}


Class* lookup_class(Class* cls, const char *name) {
    Class *c = cls;
    while (c) {
        if (strcmp(c->name, name) == 0) return c;
        c = c->next;
    }
    return NULL;
}

Function* lookup_feature(Class* cls, const char *feature_name) {
    if (!cls) return NULL;
    Function *f = cls->features;
    while (f) {
        if (strcmp(f->name, feature_name) == 0) return f;
        f = f->next;
    }
    return NULL;
}
