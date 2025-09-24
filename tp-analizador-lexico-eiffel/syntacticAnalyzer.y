%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char *str;
}

/* --- tokens --- */
%token <str> CLASS CREATE FEATURE DO END IF THEN ELSE FROM UNTIL LOOP INHERIT MAIN MAKE PRINT
%token <str> IDENTIFIER RESERVED_TYPE
%token <str> NUMBER STRING TRUE FALSE
%token <str> PLUS MINUS TIMES DIVIDE ASSIGN EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL PARENTHESIS_OPEN PARENTHESIS_CLOSE COLON COMMA NOT NOT_EQUAL AND OR COMMENT
%token <str> UNKNOWN

%%

input:
    /* vacío */
    | input token_line
    ;

token_line:
      CLASS                     { printf("TOKEN_CLASS                   -> %s\n", $1); free($1); }
    | CREATE                    { printf("TOKEN_CREATE                  -> %s\n", $1); free($1); }
    | FEATURE                   { printf("TOKEN_FEATURE                 -> %s\n", $1); free($1); }
    | DO                        { printf("TOKEN_DO                      -> %s\n", $1); free($1); }
    | END                       { printf("TOKEN_END                     -> %s\n", $1); free($1); }
    | IF                        { printf("TOKEN_IF                      -> %s\n", $1); free($1); }
    | THEN                      { printf("TOKEN_THEN                    -> %s\n", $1); free($1); }
    | ELSE                      { printf("TOKEN_ELSE                    -> %s\n", $1); free($1); }
    | FROM                      { printf("TOKEN_FROM                    -> %s\n", $1); free($1); }
    | UNTIL                     { printf("TOKEN_UNTIL                   -> %s\n", $1); free($1); }
    | LOOP                      { printf("TOKEN_LOOP                    -> %s\n", $1); free($1); }
    | INHERIT                   { printf("TOKEN_INHERIT                 -> %s\n", $1); free($1); }
    | MAKE                      { printf("TOKEN_MAKE                    -> %s\n", $1); free($1); }
    | MAIN                      { printf("TOKEN_MAIN                    -> %s\n", $1); free($1); }
    | PRINT                     { printf("TOKEN_PRINT                   -> %s\n", $1); free($1); }

    | IDENTIFIER                { printf("TOKEN_IDENTIFIER              -> %s\n", $1); free($1); }
    | NUMBER                    { printf("TOKEN_NUMBER                  -> %s\n", $1); free($1); }
    | STRING                    { printf("TOKEN_STRING                  -> %s\n", $1); free($1); }
    | TRUE                      { printf("TOKEN_TRUE                    -> %s\n", $1); free($1); }
    | FALSE                     { printf("TOKEN_FALSE                   -> %s\n", $1); free($1); }

    | PLUS                      { printf("TOKEN_PLUS                    -> %s\n", $1); free($1); }
    | MINUS                     { printf("TOKEN_MINUS                   -> %s\n", $1); free($1); }
    | TIMES                     { printf("TOKEN_TIMES                   -> %s\n", $1); free($1); }
    | DIVIDE                    { printf("TOKEN_DIVIDE                  -> %s\n", $1); free($1); }
    | ASSIGN                    { printf("TOKEN_ASSIGN                  -> %s\n", $1); free($1); }
    | EQUAL                     { printf("TOKEN_EQUAL                   -> %s\n", $1); free($1); }
    | LESS                      { printf("TOKEN_LESS                    -> %s\n", $1); free($1); }
    | GREATER                   { printf("TOKEN_GREATER                 -> %s\n", $1); free($1); }
    | LESS_EQUAL                { printf("TOKEN_LESS_EQUAL              -> %s\n", $1); free($1); }
    | GREATER_EQUAL             { printf("TOKEN_GREATER_EQUAL           -> %s\n", $1); free($1); }
    | PARENTHESIS_OPEN          { printf("TOKEN_PARENTHESIS_OPEN        -> %s\n", $1); free($1); }
    | PARENTHESIS_CLOSE         { printf("TOKEN_PARENTHESIS_CLOSE       -> %s\n", $1); free($1); }
    | COLON                     { printf("TOKEN_SEMI                    -> %s\n", $1); free($1); }
    | COMMA                     { printf("TOKEN_COMMA                   -> %s\n", $1); free($1); }
    | RESERVED_TYPE             { printf("TOKEN_RESERVED_TYPE           -> %s\n", $1); free($1); }
    | NOT                       { printf("TOKEN_NOT                     -> %s\n", $1); free($1); }
    | NOT_EQUAL                 { printf("TOKEN_NOT_EQUAL               -> %s\n", $1); free($1); }
    | OR                        { printf("TOKEN_OR                      -> %s\n", $1); free($1); }
    | AND                       { printf("TOKEN_AND                     -> %s\n", $1); free($1); }
    | COMMENT                   { printf("TOKEN_COMMENT                 -> %s\n", $1); free($1); }

    | UNKNOWN                   { printf("TOKEN_UNKNOWN                 -> %s\n", $1); free($1); }
    ;

%%

int main(void) {
    return yyparse();
}

/* funcion utilizada cuando devuelve un error */
void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
