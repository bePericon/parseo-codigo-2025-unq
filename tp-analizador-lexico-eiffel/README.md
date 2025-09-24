# Analizador léxico de Eiffel


## Compilación y ejecución con Flex|Bison
```
    flex eiffel.l 
    bison -d syntacticAnalyzer.y
    gcc -o executable lex.yy.c syntacticAnalyzer.tab.c
    ./executable < test.e 
```
