Compile:
lex filename.l
yacc -dv filename.y
gcc lex.yy.c y.tab.c -lfl -o out