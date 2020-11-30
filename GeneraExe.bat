C:\FlexBisonC\GnuWin32\bin\flex EA3.l
pause
C:\FlexBisonC\GnuWin32\bin\bison -dyv EA3.y
pause
C:\FlexBisonC\GnuWin32\MinGW\bin\gcc.exe lex.yy.c y.tab.c lib/* -o EA3.exe
pause
pause
EA3.exe test.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del EA3.exe
pause