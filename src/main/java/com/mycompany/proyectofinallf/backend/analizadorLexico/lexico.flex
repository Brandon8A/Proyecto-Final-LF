package com.mycompany.proyectofinallf.backend.analizadorLexico;

import java.util.ArrayList;
import java.util.List;
import com.mycompany.proyectofinallf.backend.token.Token;

%%
%{
    // Código Java
    private List<Token> lista = new ArrayList<>();
    private List<Token> listaErrores = new ArrayList<>();
%}

// Configuración
%public
%class AnalizadorLexicoDB
%unicode
%line
%column
%standalone

// EXPRESIONES REGULARES
// CREATE
DATABASE = "DATABASE"
TABLE = "TABLE"
KEY = "KEY"
NULL = "NULL"
PRIMARY = "PRIMARY"
UNIQUE = "UNIQUE"
FOREIGN = "FOREIGN"
REFERENCES = "REFERENCES"
ALTER = "ALTER"
ADD = "ADD"
COLUMN = "COLUMN"
TYPE = "TYPE"
DROP = "DROP"
CONSTRAINT = "CONSTRAINT"
IF = "IF"
EXIST = "EXIST"
CASCADE = "CASCADE"
ON = "ON"
DELETE = "DELETE"
SET = "SET"
UPDATE = "UPDATE"
INSERT = "INSERT"
INTO = "INTO"
VALUES = "VALUES"
SELECT = "SELECT"
FROM = "FROM"
WHERE = "WHERE"
AS = "AS"
GROUP = "GROUP"
ORDER = "ORDER"
BY = "BY"
ASC = "ASC"
DESC = "DESC"
LIMIT = "LIMIT"
JOIN = "JOIN"
// TIPO DE DATO
INTEGER = "INTEGER"
BIGINT = "BIGINT"
VARCHAR = "VARCHAR"
DECIMAL = "DECIMAL"
DATE = "DATE"
TEXT = "TEXT"
BOOLEAN = "BOOLEAN"
SERIAL = "SERIAL"
// ENTERO
ENTERO = [0-9]+
// DECIMAL
DECIMAL = {ENTERO} "." {ENTERO}
// FECHA
FECHA = '\'' [0-9]{4} '-' [0-9]{2} '-' [0-9]{2} '\'' 
// CADENA EN COMILLAS SIMPLES
CADENA = '\'' (\\\'|[^\'])* '\'' 
// IDENTIFICADOR
IDENTIFICADOR = [a-z]+
// BOOLEANO
TRUE = "TRUE"
FALSE = "FALSE"
// FUNCIONES DE AGREGACION
SUM = "SUM"
AVG = "AVG"
COUNT = "COUNT"
MAX = "MAX"
MIN = "MIN"
// SIGNOS
PARENTESIS_IZQUIERDO = '\('
PARENTESIS_DERECHO = '\)'
COMA = ','
PUNTO_Y_COMA = ';'
PUNTO = '.'
IGUAL = '='
// SIGNOS ARITMETICOS
SUMA = '\+'
RESTA = '\-'
MULTIPLICACION = '\*'
DIVISION = '\/'
// SIGNOS RELACIONALES
MENOR = '<'
MAYOR = '>'
MENOR_IGUAL = '<='
MAYOR_IGUAL = '>='
// SIGNOS LOGICOS
AND = "AND"
OR = "OR"
NOT = "NOT"
// ESTADOS
%state CONSULTA_SQL
%state COMENTARIO_LINEA
%state CREATE
%state IDENTIFICADOR
%%

// REGLAS DE ESCANEO
<YYINITIAL>{
    "CREATE"        {yybegin(CREATE); System.out.println("Iniciando en initial, pasando a "+yytext());}
}
<CREATE>{
    "DATABASE"      {yybegin(IDENTIFICADOR);System.out.println("De CREATE "+ yytext()+" a IDENTIFICADOR");}
    "TABLE"         {yybegin(IDENTIFICADOR);System.out.println("De CREATE "+ yytext()+" a IDENTIFICADOR");}
}
<IDENTIFICADOR>{
    {IDENTIFICADOR} {System.out.println("Nombre identificador: " +yytext());}
}
<COMENTARIO_LINEA>{
    "\n"        {yybegin(CONSULTA_SQL); System.out.println("Cambiando a consulta SQL. ");}
    .           {System.out.println("Parte del comentario: " + yytext());}
}