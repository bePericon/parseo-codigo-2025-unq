# Analizador léxico de Eiffel


## Compilación y ejecución con Flex|Bison
```
    flex eiffel.l 
    bison -d sintacticAnalizer.y
    gcc -o executable lex.yy.c sintacticAnalizer.tab.c
    ./executable < test.e 
```