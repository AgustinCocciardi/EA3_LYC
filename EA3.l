%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"
#define TOPE_ENTERO 65535

FILE *yyin;
int yylval;
char *yyltext;

%}

%option noyywrap
%option yylineno

DIGITO				[0-9]
POSITIVO            [1-9]
LETRA				[a-zA-Z]
DELIM				[ \t\r]
CARACTER			[a-z,A-Z,0-9,=,>,<,!,:,+,-,*,/,?,¿,!,¡,@,%,#,&,°,´,^,`,~,/,\\,-,_,"."",;,¬,\,À-ÿ,|]
VALID_STRING		({CARACTER}+|{DELIM})*

id					{LETRA}({LETRA}|{DIGITO})*
cte                 {POSITIVO}{DIGITO}*
write               "WRITE"|"write"
read                "READ"|"read"
posicion            "POSICION"|"posicion"
asigna              "="
para                "("
parc                ")"
ca                  "["
cc                  "]"
coma                ","
pyc                 ";"
cte_s			    \"{VALID_STRING}\"

%%

{write}             {return write;}
{read}              {return read;}
{posicion}          {return posicion;}
{id}                {return id;}
{cte}               {return cte;}
{asigna}            {return asigna;}
{para}              {return para;}
{parc}              {return parc;}
{ca}                {return ca;}
{cc}                {return cc;}
{coma}              {return coma;}
{pyc}               {return pyc;}
{cte_s}             {return cte_s;}

" "
"\n"
"\t"
%%
