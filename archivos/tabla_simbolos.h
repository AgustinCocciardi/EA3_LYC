
#ifndef tabla_simbolos_h
#define tabla_simbolos_h

/* Tipos de datos para la tabla de simbolos */
#define Int 1
#define CteInt 4
#define CteString 6

#define TAMANIO_TABLA 150
#define LONGITUD_CADENA 200

/* Funciones */
int agregarVarATabla(char* nombre, int tipo);
int agregarConstanteteStringATabla(char* nombre);
int agregarCteIntATabla(int valor);

int buscarEnTabla(char * name);
int buscarStringEnTabla(char * name);
int buscarIDEnTabla(char * name);
void escribirNombreEnTabla(char* nombre, int pos);
void guardarTabla(void);

int yyerror(char* mensaje);

typedef struct {
  char nombre[LONGITUD_CADENA];
  int tipo_dato;
  char valor_s[LONGITUD_CADENA];
  float valor_f;
  int valor_i;
  int longitud;
} simbolo;

/* Variables externas */
extern simbolo tabla_simbolo[TAMANIO_TABLA];
extern int fin_tabla; /* Apunta al ultimo registro en la tabla de simbolos. Incrementarlo para guardar el siguiente. */
#endif
