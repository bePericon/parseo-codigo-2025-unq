# Parser de Eiffel

### Compilación y Ejecución

El proyecto incluye un Makefile automatizado para facilitar la compilación y las pruebas.

#### Requisitos

- GCC (Compilador de C)
- Flex y Bison
- Make

#### Comandos

- Compilar todo:
Esto genera los archivos lex.yy.c, parser.tab.c y compila el ejecutable executable.

```
make build
```


- Ejecutar un archivo específico:

```
make run FILE=examples/01_hello.e
```

- Correr pruebas:
Este comando busca automáticamente todos los archivos .e en la carpeta examples/ y los ejecuta secuencialmente, mostrando los resultados en consola.

```
make test
```

- Limpiar:

```
make clean
```