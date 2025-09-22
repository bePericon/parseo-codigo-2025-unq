# Analizador léxico de Eiffel


## Compilación con Flex
```
    flex eiffel.l 
    gcc lex.yy.c -o executable
    ./executable < test.e 
```