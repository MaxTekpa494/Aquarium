CC = gcc
CFLAGS = -Wall -g -Iobj -Isrc
PARSER = parser
LEXER = flex
BIN_DIR = bin
OBJ_DIR = obj
EXEC = tpcas

all: $(OBJ_DIR) $(BIN_DIR) $(BIN_DIR)/$(EXEC)

$(BIN_DIR)/$(EXEC): obj/$(LEXER).o obj/$(PARSER).o obj/tree.o obj/main.o
	$(CC) -o $@ $^

$(OBJ_DIR)/tree.o: src/tree.c src/tree.h

$(OBJ_DIR)/$(PARSER).o: obj/$(PARSER).c src/tree.h

$(OBJ_DIR)/$(LEXER).o: obj/$(LEXER).c obj/$(PARSER).h

$(OBJ_DIR)/main.o: src/main.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJ_DIR)/%.o: src/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(OBJ_DIR)/$(LEXER).c: src/$(LEXER).lex obj/$(PARSER).h
	flex -o $@ $<

$(OBJ_DIR)/$(PARSER).c $(OBJ_DIR)/$(PARSER).h: src/$(PARSER).y
	bison -d -o $(OBJ_DIR)/$(PARSER).c $<

$(OBJ_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

