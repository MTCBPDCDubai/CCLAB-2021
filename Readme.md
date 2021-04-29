# CC Lab 2021
### Compile
```
lex filename.l\n
yacc -dv filename.y\n  
gcc lex.yy.c y.tab.c -lfl -o out\n
```