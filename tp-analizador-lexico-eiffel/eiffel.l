/*** Definition Section ***/
%{
%}

IDENTIFIER [a-zA-Z][0-9_a-zA-Z]*
NUMBER [0-9]*
STRING \"[^\"]*\"
RESERVED_TYPE (INTEGER|BOOLEAN|STRING)
COMMENT \-{2}.*


/*** Rule Section ***/
%%

"class"           {printf("%s CLASS\n", yytext); return CLASS; }
"inherit"         {printf("%s INHERIT\n", yytext); return INHERIT; }
"create"          {printf("%s CREATE\n", yytext); return CREATE; }
"feature"         {printf("%s FEATURE\n", yytext); return FEATURE; }
"main"            {printf("%s MAIN\n", yytext); return MAIN; }
"do"              {printf("%s DO\n", yytext); return DO; }
"from"            {printf("%s FROM\n", yytext); return FROM; }
"until"           {printf("%s UNTIL\n", yytext); return UNTIL; }
"loop"            {printf("%s LOOP\n", yytext); return LOOP; }
"end"             {printf("%s END\n", yytext); return END; }
"if"              {printf("%s IF\n", yytext); return IF; }
"then"            {printf("%s THEN\n", yytext); return THEN; }
"else"            {printf("%s ELSE\n", yytext); return ELSE; }
"make"            {printf("%s MAKE\n", yytext); return MAKE; }
"print"           {printf("%s PRINT\n", yytext); return PRINT; }
{RESERVED_TYPE}   {printf("%s RESERVED_TYPE\n", yytext); return RESERVED_TYPE; }

"+"               {printf("%s PLUS\n", yytext); return PLUS; }
"-"               {printf("%s MINUS\n", yytext); return MINUS; }
"*"               {printf("%s TIMES\n", yytext); return TIMES; }
"/"               {printf("%s DIVIDE\n", yytext); return DIVIDE; }
">"               {printf("%s GREATER\n", yytext); return GREATER; }
"<"               {printf("%s LESS\n", yytext); return LESS; }
"="               {printf("%s EQUAL\n", yytext); return EQUAL; }
"!="              {printf("%s NOT_EQUAL\n", yytext); return NOT_EQUAL; }
">="              {printf("%s GREATER_EQUAL\n", yytext); return GREATER_EQUAL; }
"<="              {printf("%s LESS_EQUAL\n", yytext); return LESS_EQUAL; }
"not"             {printf("%s NOT\n", yytext); return NOT; }
"and"             {printf("%s AND\n", yytext); return AND; }
"or"              {printf("%s OR\n", yytext); return OR; }
"true"            {printf("%s TRUE\n", yytext); return TRUE; }
"false"           {printf("%s FALSE\n", yytext); return FALSE; }

":="              {printf("%s ASSIGN\n", yytext); return ASSIGN; }
":"               {printf("%s COLON\n", yytext); return COLON; }
","               {printf("%s COMMA\n", yytext); return COMMA; }

"("               {printf("%s PARENTHESIS_OPEN\n", yytext); return PARENTHESIS_OPEN; }
{STRING}          {printf("%s STRING\n", yytext); return STRING; } //yylval.string = strdup(buffer);
")"               {printf("%s PARENTHESIS_CLOSE\n", yytext); return PARENTHESIS_CLOSE; }

{COMMENT}         {printf("%s COMMENT\n", yytext); return COMMENT; }
{IDENTIFIER}      {printf("%s IDENTIFIER\n", yytext); return IDENTIFIER; }
{NUMBER}          {printf("%s NUMBER\n", yytext); return NUMBER; }

[ \t\n\r]+        ;   // ignorar espacios y saltos
.                 { printf("Carácter no reconocido: %s\n", yytext);; }

%%
/*** Code Section ***/
int yywrap(){}
int main(){
yylex();
      printf("\nFinished.\n");
      return 0;
}