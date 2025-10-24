/*** Definition Section ***/
%option noyywrap
%{
#include "parser.tab.h"

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
"class"                 {yylval.str = strdup(yytext); return CLASS; }
"create"                {yylval.str = strdup(yytext); return CREATE; }
"feature"               {yylval.str = strdup(yytext); return FEATURE; }
"do"                    {yylval.str = strdup(yytext); return DO; }
"from"                  {yylval.str = strdup(yytext); return FROM; }
"until"                 {yylval.str = strdup(yytext); return UNTIL; }
"loop"                  {yylval.str = strdup(yytext); return LOOP; }
"end"                   {yylval.str = strdup(yytext); return END; }
"if"                    {yylval.str = strdup(yytext); return IF; }
"then"                  {yylval.str = strdup(yytext); return THEN; }
"else"                  {yylval.str = strdup(yytext); return ELSE; }
"print"                 {yylval.str = strdup(yytext); return PRINT; }
"true"                  {yylval.str = strdup(yytext); return TRUE; }
"false"                 {yylval.str = strdup(yytext); return FALSE; }
{RESERVED_TYPE}         {yylval.str = strdup(yytext); return RESERVED_TYPE; }

"+"                     {yylval.str = strdup(yytext); return PLUS; }
"-"                     {yylval.str = strdup(yytext); return MINUS; }
"*"                     {yylval.str = strdup(yytext); return TIMES; }
"/"                     {yylval.str = strdup(yytext); return DIVIDE; }
">"                     {yylval.str = strdup(yytext); return GREATER; }
"<"                     {yylval.str = strdup(yytext); return LESS; }
"="                     {yylval.str = strdup(yytext); return EQUAL; }
"!="                    {yylval.str = strdup(yytext); return NOT_EQUAL; }
">="                    {yylval.str = strdup(yytext); return GREATER_EQUAL; }
"<="                    {yylval.str = strdup(yytext); return LESS_EQUAL; }
"not"                   {yylval.str = strdup(yytext); return NOT; }
"and"                   {yylval.str = strdup(yytext); return AND; }
"or"                    {yylval.str = strdup(yytext); return OR; }
":="                    {yylval.str = strdup(yytext); return ASSIGN; }
":"                     {yylval.str = strdup(yytext); return COLON; }
","                     {yylval.str = strdup(yytext); return COMMA; }
"("                     {yylval.str = strdup(yytext); return PARENTHESIS_OPEN; }
")"                     {yylval.str = strdup(yytext); return PARENTHESIS_CLOSE; }

{COMMENT}               {yylval.str = strdup(yytext); return COMMENT; }
{NUMBER}                {yylval.str = strdup(yytext); return NUMBER; }
{REAL}                  {yylval.str = strdup(yytext); return REAL; }
{STR}                   {yylval.str = strdup(yytext); return STRING; }

{IDENTIFIER}            {yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t\n\r]+              ;   // skip spaces and new lines
.                       { yylval.str = strdup(yytext); return UNKNOWN; }

%%
