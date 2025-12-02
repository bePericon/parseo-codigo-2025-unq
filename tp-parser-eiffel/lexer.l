/*** Definition Section ***/
%option noyywrap yylineno
%{
#include "parser.tab.h"
#include <string.h>

int yycolumn = 1;
%}

DIGIT       [0-9]
IDENTIFIER [a-zA-Z][0-9_a-zA-Z]*
NUMBER {DIGIT}+
NEG_NUMBER \-{1}{NUMBER}
REAL ({DIGIT}+\.[0-9]*([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+)
STR \"[^\"]*\"
RESERVED_TYPE (INTEGER|BOOLEAN|STRING)
COMMENT \-{2}.*


/*** Rule Section ***/
%%
"class"                 {yylval.str = strdup(yytext); yycolumn += yyleng; return CLASS; }
"local"                 {yylval.str = strdup(yytext); yycolumn += yyleng; return LOCAL; }
"feature"               {yylval.str = strdup(yytext); yycolumn += yyleng; return FEATURE; }
"do"                    {yylval.str = strdup(yytext); yycolumn += yyleng; return DO; }
"from"                  {yylval.str = strdup(yytext); yycolumn += yyleng; return FROM; }
"until"                 {yylval.str = strdup(yytext); yycolumn += yyleng; return UNTIL; }
"loop"                  {yylval.str = strdup(yytext); yycolumn += yyleng; return LOOP; }
"end"                   {yylval.str = strdup(yytext); yycolumn += yyleng; return END; }
"if"                    {yylval.str = strdup(yytext); yycolumn += yyleng; return IF; }
"then"                  {yylval.str = strdup(yytext); yycolumn += yyleng; return THEN; }
"else"                  {yylval.str = strdup(yytext); yycolumn += yyleng; return ELSE; }
"print"                 {yylval.str = strdup(yytext); yycolumn += yyleng; return PRINT; }
"true"                  {yylval.str = strdup(yytext); yycolumn += yyleng; return TRUE; }
"false"                 {yylval.str = strdup(yytext); yycolumn += yyleng; return FALSE; }
{RESERVED_TYPE}         {yylval.str = strdup(yytext); yycolumn += yyleng; return RESERVED_TYPE; }
"create"                {yylval.str = strdup(yytext); yycolumn += yyleng; return CREATE; }

"+"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return PLUS; }
"-"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return MINUS; }
"*"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return TIMES; }
"/"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return DIVIDE; }
">"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return GREATER; }
"<"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return LESS; }
"="                     {yylval.str = strdup(yytext); yycolumn += yyleng; return EQUAL; }
"!="                    {yylval.str = strdup(yytext); yycolumn += yyleng; return NOT_EQUAL; }
">="                    {yylval.str = strdup(yytext); yycolumn += yyleng; return GREATER_EQUAL; }
"<="                    {yylval.str = strdup(yytext); yycolumn += yyleng; return LESS_EQUAL; }
"not"                   {yylval.str = strdup(yytext); yycolumn += yyleng; return NOT; }
"and"                   {yylval.str = strdup(yytext); yycolumn += yyleng; return AND; }
"or"                    {yylval.str = strdup(yytext); yycolumn += yyleng; return OR; }
":="                    {yylval.str = strdup(yytext); yycolumn += yyleng; return ASSIGN; }
":"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return COLON; }
","                     {yylval.str = strdup(yytext); yycolumn += yyleng; return COMMA; }
"("                     {yylval.str = strdup(yytext); yycolumn += yyleng; return PARENTHESIS_OPEN; }
")"                     {yylval.str = strdup(yytext); yycolumn += yyleng; return PARENTHESIS_CLOSE; }
"."                     {yylval.str = strdup(yytext); yycolumn += yyleng; return DOT; }

{COMMENT}               {} // Discard comments
{NUMBER}                {yylval.str = strdup(yytext); yycolumn += yyleng; return NUMBER; }
{NEG_NUMBER}            {yylval.str = strdup(yytext); yycolumn += yyleng; return NEG_NUMBER; }
{REAL}                  {yylval.str = strdup(yytext); yycolumn += yyleng; return REAL; }
{STR}                   {yylval.str = strdup(yytext); yycolumn += yyleng; return STRING; }

{IDENTIFIER}            {yylval.str = strdup(yytext); yycolumn += yyleng; return IDENTIFIER; }

\n                      { yylineno++; yycolumn = 1; }
[ \t\r]+                { yycolumn += yyleng; }
.                       { yylval.str = strdup(yytext); yycolumn += yyleng;return UNKNOWN; }

%%
