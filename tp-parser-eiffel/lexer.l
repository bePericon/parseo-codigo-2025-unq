/*** Definition Section ***/
%option noyywrap
%{
#include "parser.tab.h"
#include <string.h>

int yycolumn = 1;
%}

DIGIT       [0-9]
IDENTIFIER [a-zA-Z][0-9_a-zA-Z]*
NUMBER {DIGIT}+
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

{COMMENT}               {yylval.str = strdup(yytext); yycolumn += yyleng; return COMMENT; }
{NUMBER}                {yylval.str = strdup(yytext); yycolumn += yyleng; return NUMBER; }
{REAL}                  {yylval.str = strdup(yytext); yycolumn += yyleng; return REAL; }
{STR}                   {yylval.str = strdup(yytext); yycolumn += yyleng; return STRING; }

{IDENTIFIER}            {yylval.str = strdup(yytext); yycolumn += yyleng; return IDENTIFIER; }

\n                      { yylineno++; yycolumn = 1; }
[ \t\r]+                { yycolumn += yyleng; }
.                       { yylval.str = strdup(yytext); yycolumn += yyleng;return UNKNOWN; }

%%
