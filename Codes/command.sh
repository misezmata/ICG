clear
yacc -d -y -Wno-other -Wno-yacc 1805090.y && g++ -w -c -o y.o y.tab.c 
flex 1805090.l && g++ -fpermissive -w -c  -o l.o lex.yy.c 
g++ y.o l.o -lfl -o test
./test mytest.c code2.asm