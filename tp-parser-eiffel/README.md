# Parser de Eiffel


## Compilación y ejecución con Flex|Bison
```
    flex lexer.l 
    bison -d parser.y
    gcc -o executable lex.yy.c parser.tab.c
    ./executable < test.e 
```
