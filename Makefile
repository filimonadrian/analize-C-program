# FILIMON ADRIAN 334CC
CC=gcc
LEX=flex
LDFLAGS=-lfl
CFALGS=-c -g

build: tema.l
	$(LEX) tema.l
	$(CC) lex.yy.c -o tema $(LDFLAGS)

run1: tema
	./tema input1.in

run2: tema
	./tema input2.in

run3: tema
	./tema input3.in

clean: tema
	rm -rf tema lex.yy.c
