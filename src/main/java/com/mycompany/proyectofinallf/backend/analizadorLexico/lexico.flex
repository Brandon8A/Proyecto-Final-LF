package com.mycompany.proyectofinallf.backend.analizadorLexico;

import java.util.ArrayList;
import java.util.List;
import com.mycompany.proyectofinallf.backend.token.Token;
import com.mycompany.proyectofinallf.backend.token.TipoToken;
import com.mycompany.proyectofinallf.backend.PintarPalabras;

%%
%{
    // Código Java
    private final String NARANJA = "#F0A30A";
    private final String MORADO = "#6A00FF";
    private final String AZUL = "#414ED9";
    private final String AMARILLO = "#FFD300";
    private final String VERDE = "#60A917";
    private final String FUCSIA = "#D80073";
    private final String NEGRO = "#000000";
    private final String GRIS = "#757575";

    private List<Token> listaTokens = new ArrayList<>();
    private List<Token> listaErrores = new ArrayList<>();
    public PintarPalabras pintar = new PintarPalabras();
    private int contadorSaltosDeLinea = 0;

    public void añadirToken(Token token){
        listaTokens.add(token);
    }

    public List<Token> getListaTokens(){
        return listaTokens;
    }
%}

// Configuración
%public
%class AnalizadorLexicoDB
%unicode
%line
%column
%standalone

// EXPRESIONES REGULARES
//ESPACIOS
ESPACIOS = [" "\r\t\b\n]
// ENTERO
ENTERO = [0-9]+
// DECIMAL
DECIMAL = {ENTERO} "." {ENTERO}
// FECHA
FECHA = '\'' [0-9]{4} '-' [0-9]{2} '-' [0-9]{2} '\'' 
// CADENA EN COMILLAS SIMPLES
CADENA = '\'' (\\\'|[^\'])* '\'' 
// IDENTIFICADOR
IDENTIFICADOR = [a-z]+[_(a-z0-9)]*
//ESPACIOS
ESPACIOS = [" "\r\t\b\n]
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
SIGNOS_LOGICOS = ("AND", "OR", "NOT")
// ESTADOS
%state CONSULTA_SQL
%state COMENTARIO_LINEA
%state DDL
%state IDENTIFICADOR
%state SIGNOS
%state TIPO_DE_DATO
%state ESTRUCTURA_DECLARACION_TABLAS
%state ATRIBUTOS_TABLA
%state DEFINIR_VALOR
%state ESTABLECER_VALOR_NO_NULO
%state CONSTRUIR_LLAVE

%%

// REGLAS DE ESCANEO
<YYINITIAL>{
    \n                  {System.out.println("Salto de linea, aumentar en 1"); contadorSaltosDeLinea++;}
    "CREATE"            {pintar.pintarPalabra((int)yychar,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DDL);}
    "ALTER"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ADD"               {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "COLUMN"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "TYPE"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DROP"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "IF"                {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "EXIST"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "CASCADE"           {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ON"                {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DELETE"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "SET"               {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "UPDATE"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "INSERT"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "INTO"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "VALUES"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "SELECT"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "FROM"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "WHERE"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "AS"                {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "GROUP"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ORDER"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "BY"                {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ASC"               {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DESC"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "LIMIT"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "JOIN"              {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}
<DDL>{
    \n                  {contadorSaltosDeLinea++;}
    "DATABASE"          {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(IDENTIFICADOR);}
    "TABLE"             {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(IDENTIFICADOR);}
}
<IDENTIFICADOR>{
    \n                  {System.out.println("Salto de linea, aumentar en 1"); contadorSaltosDeLinea++;}
    {IDENTIFICADOR}     {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,FUCSIA); añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn)); yybegin(SIGNOS);}
}
<SIGNOS>{
    \n                  {contadorSaltosDeLinea++;}
    "("                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
    ")"                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(YYINITIAL);}
    ","                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "."                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "="                 {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NEGRO); añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
}
<ESTRUCTURA_DECLARACION_TABLAS>{
    \n                  {contadorSaltosDeLinea++;}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn)); yybegin(TIPO_DE_DATO);}
    "CONSTRAINT"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(CONSTRUIR_LLAVE);}
}
<TIPO_DE_DATO>{
    \n                  {contadorSaltosDeLinea++;}
    "INTEGER"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "BIGINT"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "VARCHAR"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "DECIMAL"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "NUMERIC"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "DATE"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "TEXT"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "BOOLEAN"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
    "SERIAL"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(ATRIBUTOS_TABLA);}
}
<ATRIBUTOS_TABLA>{
    \n                  {contadorSaltosDeLinea++;}
    "PRIMARY"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "NOT"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(DEFINIR_VALOR);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
}
<ESTABLECER_VALOR_NO_NULO>{
    \n                  {contadorSaltosDeLinea++;}
    "NOT"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
    "NULL"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    "UNIQUE"            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,NARANJA); añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}
<DEFINIR_VALOR>{
    \n                  {contadorSaltosDeLinea++;}
    {ENTERO}            {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,AZUL); añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {pintar.pintarPalabra(yycolumn,yylength()+contadorSaltosDeLinea,AZUL); añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
}
<CONSTRUIR_LLAVE>{
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "FOREIGN"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "REFERENCES"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}