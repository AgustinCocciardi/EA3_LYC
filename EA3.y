%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
    #include "./lib/tabla_simbolos.h"
    #include "./lib/tercetos.h"
    #include "./lib/assembler.h"

	int yyerror(char* mensaje);
	int yyerror();
	int yylex();

    int yystopparser=0;
    FILE  *yyin;

    /*PARA EL ARMADO DE LA TABLA DE SIMBOLOS*/
	simbolo tabla_simbolo[TAMANIO_TABLA];
    int fin_tabla = -1;

    /*AL MOMENTO DE ASIGNAR*/
	char idAsignar[TAM_NOMBRE];
    char pivot[TAM_NOMBRE];
    int esListaVacia;
    int cantidadElementos;

    /*LOS INDICES PARA LOS NO TERMINALES DEFINIDOS EN LAS REGLAS*/
	int wIND;
    int rIND;
    int terceto_Que_Se_Modifica;
    int aIND;
    int lIND;
    int pIND;
    int sIND;
    int stIND;
    int prIND;
    int terceto_Lista_Vacia;
    int terceto_pivot;
    int terceto_Auxiliar;
    int fIND;
    int jIND;

    /*PARA TERCETOS*/
	terceto lista_terceto[MAX_TERCETOS];
	int ultimo_terceto = -1; /*Me dice donde está el ultimo terceto escrito*/

%}

%union {
	int int_val;
	char *string_val;
}

%token ASIGNA

%token PARA PARC
%token CA CC
%token COMA
%token PYC

%token READ
%token WRITE
%token POSICION

%token <string_val>ID
%token <int_val>CTE
%token <string_val>CTE_S

%%

start:
	programa									        {
                                                            
                                                            fIND = crear_terceto(JMP,SIN_OPERADOR,SIN_OPERADOR);
                                                            stIND = prIND;
                                                            int pos = agregarCteStringATabla("El valor debe ser >=1");
                                                            crear_terceto(ETIQUETA,SIN_OPERADOR,SIN_OPERADOR);
                                                            modificarTerceto(terceto_pivot,OP1,ultimo_terceto + OFFSET);
                                                            crear_terceto(WRITE,pos,SIN_OPERADOR);
                                                            if(esListaVacia){
                                                                int pos= agregarCteStringATabla("La lista esta vacia");
                                                                crear_terceto(ETIQUETA,SIN_OPERADOR,SIN_OPERADOR);
                                                                modificarTerceto(terceto_Lista_Vacia,OP1,ultimo_terceto + OFFSET);
                                                                wIND = crear_terceto(WRITE, pos, SIN_OPERADOR);
                                                                jIND = crear_terceto(JMP, SIN_OPERADOR,SIN_OPERADOR);
                                                            }else{
                                                                jIND = crear_terceto(JMP, SIN_OPERADOR,SIN_OPERADOR);
                                                                pos = agregarCteStringATabla("La posicion no se encontro");
                                                                crear_terceto(ETIQUETA,SIN_OPERADOR,SIN_OPERADOR);
                                                                modificarTerceto(terceto_Auxiliar,OP1,ultimo_terceto+OFFSET);
															    crear_terceto(WRITE,pos,SIN_OPERADOR);
                                                            }

                                                            //Ultimo terceto que será creado
                                                            pos = agregarCteStringATabla("FIN PROGRAMA");
                                                            crear_terceto(ETIQUETA,SIN_OPERADOR,SIN_OPERADOR);

                                                            //Cambiar los últimos tercetos
                                                            modificarTerceto(fIND,OP1,ultimo_terceto + OFFSET);
                                                            modificarTerceto(jIND,OP1,ultimo_terceto + OFFSET);

                                                            crear_terceto(WRITE,pos,SIN_OPERADOR);
                                                            
                                                            optimizarTercetos();
                                                            guardarTabla();
                                                            guardarTercetos();
                                                            generarAssembler();
														};
                                                       
/* Seccion de codigo */
programa:                                                 
	programa sentencia	                                {
                                                            printf("REGLA 2: PROG -> PROG SENT\n");
    }
	| sentencia			                                {
                                                            printf("REGLA 1: PROG -> SENT\n");
                                                            prIND = sIND;
                                                        };

sentencia:
	asignacion			                                {
															printf("REGLA 3: SENT -> ASIG\n");
                                                            sIND = aIND;
														}
	| lectura                                           {
															printf("REGLA 3: SENT -> READ\n");
                                                            sIND = rIND;
														}
	| escritura                                         {
															printf("REGLA 3: SENT -> WRITE\n");
                                                            sIND = wIND;
														};
/* Otras cosas */

asignacion:
	ID ASIGNA {strcpy(idAsignar, $1);} posicion	    {
															printf("REGLA 5: ASIG -> id asigna POSICION\n");
															
                                                            if(!esListaVacia){
																int constante = agregarCteIntATabla(0);
																int pos = buscarIDEnTabla("@pos");
                                                                int identificador = agregarVarATabla($1,Int);
                                                                crear_terceto(ETIQUETA,SIN_OPERADOR, SIN_OPERADOR);
																crear_terceto(CMP,pos,constante);
																terceto_Auxiliar = crear_terceto(BEQ,SIN_OPERADOR,SIN_OPERADOR);
                                                                aIND = crear_terceto(ASIGNA,identificador,pos);
                                                            }
                                                            
														};
posicion:
    POSICION PARA ID PYC CA {strcpy(pivot, $3);} lista CC PARC      {
                                                                        printf("REGLA 6: POSICION -> posicion para id pyc ca LISTA cc parc\n");
                                                                        esListaVacia = 0;
                                                                        pIND = lIND;
                                                                    }
    | POSICION PARA ID PYC CA CC PARC                   {
                                                            printf("REGLA 7: POSICION -> posicion para id pyc ca cc parc\n");
                                                            esListaVacia = 1;
                                                            terceto_Lista_Vacia = crear_terceto(JMP, SIN_OPERADOR, SIN_OPERADOR);
                                                        };
lista:
    lista COMA CTE                                      {
                                                            printf("REGLA 9: LISTA -> LISTA coma cte \n");
                                                            cantidadElementos++;
                                                            int constante = agregarCteIntATabla(yylval.int_val);
                                                            int posicion_A_Buscar = buscarIDEnTabla("@pos");
                                                            int pivote = buscarIDEnTabla(pivot);
                                                            crear_terceto(ETIQUETA,SIN_OPERADOR, SIN_OPERADOR);
                                                            crear_terceto(CMP,pivote, constante);
                                                            int terceto_Destino = ultimo_terceto+5;
                                                            terceto_Que_Se_Modifica = crear_terceto(BNE,terceto_Destino+OFFSET, SIN_OPERADOR); 
															//modificarTerceto(terceto_Que_Se_Modifica,OP1,terceto_Destino+OFFSET);
                                                            int cteZero = agregarCteIntATabla(0);
                                                            crear_terceto(CMP,posicion_A_Buscar,cteZero);
                                                            terceto_Que_Se_Modifica = crear_terceto(BNE,SIN_OPERADOR, SIN_OPERADOR);
															constante = agregarCteIntATabla(cantidadElementos);
                                                            lIND = crear_terceto(ASIGNA,posicion_A_Buscar,constante);
                                                            modificarTerceto(terceto_Que_Se_Modifica,OP1,terceto_Destino+OFFSET);	   
                                                        }             
    | CTE                                               {
                                                            printf("REGLA 8: LISTA -> cte \n");
                                                            // Creo una variable @pos (o la reutilizo)
                                                            cantidadElementos = 1;
                                                            int posicion_A_Buscar = agregarVarATabla("@pos", Int);
                                                            int constante = agregarCteIntATabla(yylval.int_val);
                                                            int pos = agregarCteIntATabla(0);
                                                            
                                                            int pivote = buscarIDEnTabla(pivot);
															crear_terceto(ASIGNA, posicion_A_Buscar, pos); //Inicializo @pos en 0
                                                            crear_terceto(CMP, pivote, constante);
															int terceto_Destino = ultimo_terceto+5;
                                                            terceto_Que_Se_Modifica = crear_terceto(BNE,SIN_OPERADOR, SIN_OPERADOR); 
															modificarTerceto(terceto_Que_Se_Modifica,OP1,terceto_Destino+OFFSET);
                                                            pos = agregarCteIntATabla(cantidadElementos);
                                                            constante = agregarCteIntATabla(0);
                                                            crear_terceto(CMP,posicion_A_Buscar,constante);
                                                            terceto_Que_Se_Modifica = crear_terceto(BNE,SIN_OPERADOR, SIN_OPERADOR);
                                                            lIND = crear_terceto(ASIGNA,posicion_A_Buscar,pos);
                                                            modificarTerceto(terceto_Que_Se_Modifica,OP1,terceto_Destino+OFFSET);								
                                                        };
lectura:
    READ ID												{
        													printf("REGLA 4: READ -> read id \n");
                                                            agregarVarATabla(yylval.string_val,Int);
                                                            int cota = agregarCteIntATabla(1);
                                                            int pos = buscarIDEnTabla($2);
															rIND = crear_terceto(READ, pos, SIN_OPERADOR);
                                                            crear_terceto(CMP,pos,cota);
                                                            terceto_pivot=crear_terceto(BLT, SIN_OPERADOR, SIN_OPERADOR);
														};
escritura:
    WRITE ID                                            {
															printf("REGLA 11: WRITE -> write id\n");
                                                            agregarVarATabla(yylval.string_val,Int);
                                                            int pos = buscarIDEnTabla($2);
															wIND = crear_terceto(WRITE, pos, SIN_OPERADOR);
														}
    | WRITE CTE_S                                       {
        													printf("REGLA 10: WRITE -> write cte_s\n");
                                                            int longCad = strlen($2)-2;
                                                            char cad[longCad];
                                                            strncpy(cad, $2 + 1, longCad);
                                                            cad[longCad] = '\0';
                                                            int pos= agregarCteStringATabla(cad);
                                                            wIND = crear_terceto(WRITE, pos, SIN_OPERADOR);
															
															
														};
%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  	fclose(yyin);
  }
  printf("\n* COMPILACION EXITOSA *\n");
  return 0;
}
