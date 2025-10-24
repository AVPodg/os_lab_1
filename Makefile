# Компилятор и флаги
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -pedantic -D_POSIX_C_SOURCE=200809L
DEBUG_FLAGS = -g
RELEASE_FLAGS = -O2

# Директории
SRCDIR = src
OBJDIR = obj
BINDIR = bin

# Цели
TARGET = $(BINDIR)/calculator
SOURCES = $(wildcard $(SRCDIR)/*.c)
OBJECTS = $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

# Создание необходимых директорий
$(shell mkdir -p $(OBJDIR) $(BINDIR))

# Основная цель
all: $(TARGET)

# Сборка основной программы
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^
	@echo "Сборка завершена: $@"

# Компиляция объектных файлов
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Зависимости
$(OBJDIR)/main.o: $(SRCDIR)/main.c $(SRCDIR)/child.h
$(OBJDIR)/child.o: $(SRCDIR)/child.c $(SRCDIR)/child.h

# Отладочная сборка
debug: CFLAGS += $(DEBUG_FLAGS)
debug: clean $(TARGET)

# Релизная сборка
release: CFLAGS += $(RELEASE_FLAGS)
release: clean $(TARGET)

# Тестовый файл
testfile.txt:
	@echo "Создание чистого тестового файла..."
	@echo "100 2 5" > testfile.txt
	@echo "64 4 2 2" >> testfile.txt
	@echo "100 0 5" >> testfile.txt
	@echo "81 3 3" >> testfile.txt
	@echo "120 10 3" >> testfile.txt
	@echo "Тестовый файл testfile.txt создан"

# Запуск программы
run: $(TARGET) testfile.txt
	./$(TARGET) testfile.txt

# Очистка
clean:
	rm -rf $(OBJDIR) $(BINDIR) testfile.txt
	@echo "Очистка завершена"

# Установка зависимостей (для Ubuntu/WSL)
deps:
	sudo apt update
	sudo apt install build-essential

# Проверка стиля кода
check:
	@echo "Проверка стиля кода..."
	@find $(SRCDIR) -name "*.c" -o -name "*.h" | xargs grep -l "printf" | while read file; do \
		echo "Проверка $$file"; \
		grep -n "printf" "$$file" | grep -v "//" && echo "Найдены отладочные printf в $$file"; \
	done || true

# Информация о проекте
info:
	@echo "Структура проекта:"
	@echo "  Исходные файлы: $(SRCDIR)/"
	@echo "  Объектные файлы: $(OBJDIR)/"
	@echo "  Исполняемые файлы: $(BINDIR)/"
	@echo "  Источники: $(SOURCES)"
	@echo "  Объекты: $(OBJECTS)"

# Справка
help:
	@echo "Доступные цели:"
	@echo "  all      - сборка программы (по умолчанию)"
	@echo "  debug    - отладочная сборка"
	@echo "  release  - релизная сборка"
	@echo "  run      - сборка и запуск с тестовым файлом"
	@echo "  testfile.txt - создание тестового файла"
	@echo "  clean    - очистка сборочных файлов"
	@echo "  deps     - установка зависимостей"
	@echo "  check    - проверка стиля кода"
	@echo "  info     - информация о проекте"
	@echo "  help     - эта справка"

.PHONY: all debug release run clean deps check info help