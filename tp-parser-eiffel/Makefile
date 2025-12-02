# ====================================================================

# Makefile para proyectos C
# Autor: B. Emmanuel Pericon
# Descripción: Automatiza la compilación, limpieza y ejecución de tests.

# ====================================================================

# -------------------------
# VARIABLES
# -------------------------

CC = gcc
BISON = bison
FLEX = flex

# Nombre del ejecutable final
EXECUTABLE = executable

# Archivos fuente del proyecto
SOURCE_FILES = ast.c symtab.c runtime.c interpreter.c

# Archivos de especificación (Flex/Bison)
SPEC_FILES = parser.y lexer.l

# Directorio de tests
TEST_DIR = examples

FILE ?= ./$(TEST_DIR)/00_test_default.e


# -------------------------

# TARGETS PRINCIPALES

# -------------------------

# El target por defecto compila y luego ejecuta

all: build run

TARGET: build
# Genera los archivos C de Flex/Bison y luego los compila con GCC.
.PHONY: build
build: $(EXECUTABLE)
# Regla para construir el ejecutable
$(EXECUTABLE): $(SPEC_FILES) $(SOURCE_FILES)
	@echo "-> 1. Generando lexer.lex.c..."
	$(FLEX) lexer.l

	@echo "-> 2. Generando parser.tab.c y parser.tab.h..."
	$(BISON) -d parser.y

	@echo "-> 3. Compilando: $(EXECUTABLE)..."
# Comando de compilación exacto que solicitaste
	$(CC) -o $(EXECUTABLE) lex.yy.c parser.tab.c $(SOURCE_FILES)


TARGET: run
# Ejecuta el programa compilado con un archivo de prueba.
.PHONY: run
run: $(EXECUTABLE)
	@echo "-> 4. Ejecutando ./$(EXECUTABLE) con archivo: $(FILE)..."
	./$(EXECUTABLE) < $(FILE)

TARGET: test
# Itera sobre todos los archivos *.e en la carpeta $(TEST_DIR) y los ejecuta.
.PHONY: test
test: build
	@echo "======================================================"
	@echo "-> INICIANDO PRUEBAS EN CARPETA $(TEST_DIR)"
	@echo "======================================================"
	@find $(TEST_DIR) -name "*.e" | sort > .testlist.tmp
	@while IFS= read -r test_file; do \
		echo "------------------------------------------------------"; \
		echo "EJECUTANDO: $$test_file"; \
		./$(EXECUTABLE) < "$$test_file"; \
		echo "------------------------------------------------------"; \
	done < .testlist.tmp
	@rm -f .testlist.tmp
	@echo "-> PRUEBAS COMPLETADAS."


TARGET: clean
# Elimina los archivos generados durante la compilación.
.PHONY: clean
clean:
	@echo "-> Limpiando archivos generados..."
# Elimina el ejecutable
	rm -f $(EXECUTABLE)
# Elimina los archivos C/H generados por Flex y Bison
	rm -f lex.yy.c parser.tab.c parser.tab.h