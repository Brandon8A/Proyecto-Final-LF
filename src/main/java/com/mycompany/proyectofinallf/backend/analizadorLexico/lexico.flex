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
SIGNOS_LOGICOS = ("AND"|"OR"|"NOT")
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
%state DDL_MODIFICADOR
%state IDENTIFICADOR_UNIQUE
%state IDENTIFICADOR_REFERENCES
%state IDENTIFICADOR_KEY
%state MODIFICADOR_DROP
%state DML_INSERCION
%state IDENTIFICADORES_PARA_INSERCION
%state EVALUAR_DATOS_INSERCION
%state DEFINIR_VALOR_NUEMRIC

%%

// REGLAS DE ESCANEO
//
<YYINITIAL>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "CREATE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DDL);}
    "ALTER"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DDL_MODIFICADOR);}
    "DROP"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(MODIFICADOR_DROP);}
    "ON"                {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DELETE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "SET"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "UPDATE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "INSERT"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DML_INSERCION);}
    "SELECT"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "FROM"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "WHERE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "AS"                {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "GROUP"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ORDER"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "BY"                {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ASC"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DESC"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "LIMIT"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "JOIN"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}

//CREACION DE BASES DE DATOS Y TABLAS
<DDL>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "DATABASE"          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(IDENTIFICADOR);}
    "TABLE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(IDENTIFICADOR);}
}
<IDENTIFICADOR>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn)); yybegin(SIGNOS);}
}
<SIGNOS>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(YYINITIAL);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "."                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "="                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
}
<ESTRUCTURA_DECLARACION_TABLAS>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn)); yybegin(TIPO_DE_DATO);}
    "CONSTRAINT"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(CONSTRUIR_LLAVE);}
}
<TIPO_DE_DATO>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
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
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "PRIMARY"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "NOT"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(DEFINIR_VALOR);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
}
<ESTABLECER_VALOR_NO_NULO>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "NOT"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
    "NULL"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(ESTRUCTURA_DECLARACION_TABLAS);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    "UNIQUE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}
<DEFINIR_VALOR>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(ESTABLECER_VALOR_NO_NULO);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}
<CONSTRUIR_LLAVE>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "FOREIGN"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "REFERENCES"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}

//CREACION DE MODIFICADORES
<DDL_MODIFICADOR>{
    "TABLE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "ADD"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "COLUMN"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "INTEGER"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "BIGINT"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "VARCHAR"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "DECIMAL"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "NUMERIC"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));yybegin(DEFINIR_VALOR_NUEMRIC);}
    "DATE"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "TEXT"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "BOOLEAN"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "SERIAL"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "ALTER"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "TYPE"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DROP"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "CONSTRAINT"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "FOREIGN"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "UNIQUE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(IDENTIFICADOR_UNIQUE);}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(IDENTIFICADOR_KEY);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}
<IDENTIFICADOR_UNIQUE>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}
<IDENTIFICADOR_KEY>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "REFERENCES"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(IDENTIFICADOR_REFERENCES);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}
<IDENTIFICADOR_REFERENCES>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));yybegin(IDENTIFICADOR_KEY);}
}
<MODIFICADOR_DROP>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "TABLE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "IF"                {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "EXIST"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "CASCADE"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}
<DEFINIR_VALOR_NUEMRIC>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
}

//CREACION DE INSERCION
<DML_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "INTO"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}
<IDENTIFICADORES_PARA_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "VALUES"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
}
<EVALUAR_DATOS_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
}