%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();
%}

%token  id 
%token  cte
%token  write
%token  read
%token  posicion
%token  asigna
%token  para
%token  parc
%token  ca
%token  cc
%token  coma
%token  pyc
%token  cte_s

%%

S: 
    PROG    {printf("\n\tCOMPILACION EXITOSA\n");}
    ;

PROG:
    SENT    {printf("\n\tRegla 1: PROG -> SENT\n");}
    |   PROG SENT {printf("\n\tRegla 2: PROG -> PROG SENT\n");}
    ;

SENT:
    READ    {printf("\n\tRegla 3: SENT -> READ\n");}
    |   WRITE   {printf("\n\tRegla 3: SENT -> WRITE\n");}
    |   ASIG    {printf("\n\tRegla 3: SENT -> ASIG\n");}
    ;

READ:
    read id     {printf("\n\tRegla 4: READ -> read ID\n");}
    ;

ASIG:
    id asigna POS  {printf("\n\tRegla 5: ASIG -> ID ASIGNA POS\n");}
    ;

POS:
    posicion para id parc ca LISTA cc parc  {printf("\n\tRegla 6: POS -> posicion PARA ID PARC CA LISTA CC PARC\n");}
    |   posicion para id parc ca cc parc  {printf("\n\tRegla 7: POS -> posicion PARA ID PARC CA CC PARC\n");}
    ;

LISTA:
    cte     {printf("\n\tRegla 8: LISTA -> CTE\n");}
    | LISTA coma cte    {printf("\n\tRegla 9: LISTA -> LISTA COMA CTE\n");}
    ;

WRITE:
    write cte_s     {printf("\n\tRegla 10: WRITE -> write CTE:S\n");}
    |   write id    {printf("\n\tRegla 11: WRITE -> write ID\n");}
    ;

%%

int main(int argc, char* argv[])
{
    if((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s", argv[1]);
    }
    else
    {
        yyparse();
    }
    fclose(yyin);
    return 0;
}

int yyerror(void)
{
    printf("Syntax Error\n");
    system("Pause");
    exit(1);
}
