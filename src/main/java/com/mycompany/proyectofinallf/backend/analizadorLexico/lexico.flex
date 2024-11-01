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
    private List<Token> listaTokensErrores = new ArrayList<>();
    public PintarPalabras pintar = new PintarPalabras();
    private int contadorSaltosDeLinea = 0;

    public void añadirToken(Token token){
        listaTokens.add(token);
    }

    public void añadirTokenError(Token token){
        listaTokensErrores.add(token);
    }

    public List<Token> getListaTokens(){
        return listaTokens;
    }

    public List<Token> getListaTokensErrores(){
        return listaTokensErrores;
    }

    public String descripcionTokenError(int cantidadCaracteres){
        if(cantidadCaracteres == 1){
            return "Caracter no reconocido";
        }else{
            return "Token no reconocido";
        }
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
DECIMAL = {ENTERO} ", " {ENTERO}
// FECHA
FECHA ='(\d{4}-\d{1,2}-\d{1,2})'
// CADENA EN COMILLAS SIMPLES
CADENA = '([^']*?)' 
// IDENTIFICADOR
//IDENTIFICADOR = [a-z]+[_(a-z0-9)]*
IDENTIFICADOR = [a-z]+[_a-z0-9]*
//ESPACIOS
ESPACIOS = [" "\r\t\b\n]
//SELECCION COLUMNAS ID_ID
SELECCION_COLUMNAS_ID_ID = {IDENTIFICADOR}"."{IDENTIFICADOR}
//SIGNOS LOGICOS
SIGNOS_LOGICOS = ("AND"|"OR"|"NOT")
// ESTADOS
%state CONSULTA_SQL
%state COMENTARIO_LINEA
%state DDL
%state DDL_MODIFICADOR
%state IDENTIFICADOR_UNIQUE
%state IDENTIFICADOR_REFERENCES
%state IDENTIFICADOR_KEY
%state MODIFICADOR_DROP
%state DML_INSERCION
%state IDENTIFICADORES_PARA_INSERCION
%state EVALUAR_DATOS_INSERCION
%state DEFINIR_VALOR_NUEMRIC
%state DML_LECTURA
%state IDENTIFICADOR_FUNCION_AGREGACION
%state CERRAR_IDENTIFICADOR_FUNCION_AGREGACION
%state DATO_ENTERO_LIMIT
%state DML_ACTUALIZACION
%state DML_ELIMINACION

%%

// REGLAS DE ESCANEO
//
<YYINITIAL>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "CREATE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DDL);}
    "ALTER"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DDL_MODIFICADOR);}
    "DROP"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(MODIFICADOR_DROP);}
    "DELETE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(DML_ELIMINACION);}
    "UPDATE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(DML_ACTUALIZACION);}
    "INSERT"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DML_INSERCION);}
    "SELECT"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DML_LECTURA);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}

//CREACION DE BASES DE DATOS Y TABLAS
<DDL>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "DATABASE"          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "TABLE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); }
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn)); yybegin(YYINITIAL);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "."                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "="                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "CONSTRAINT"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "FOREIGN"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "KEY"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "REFERENCES"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "INTEGER"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "BIGINT"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "VARCHAR"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "DECIMAL"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "NUMERIC"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "DATE"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "TEXT"              {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "BOOLEAN"           {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "SERIAL"            {añadirToken(new Token(yytext(), TipoToken.TIPO_DE_DATO, MORADO, yyline, yycolumn));}
    "PRIMARY"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "NOT"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "NULL"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "UNIQUE"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    .                   {añadirTokenError(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn,descripcionTokenError(yylength())));}
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
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<IDENTIFICADOR_UNIQUE>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<IDENTIFICADOR_KEY>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "REFERENCES"        {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(IDENTIFICADOR_REFERENCES);}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<IDENTIFICADOR_REFERENCES>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));yybegin(IDENTIFICADOR_KEY);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<MODIFICADOR_DROP>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "TABLE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "IF"                {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "EXIST"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "CASCADE"           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<DEFINIR_VALOR_NUEMRIC>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}

//CREACION DE INSERCION
<DML_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "INTO"              {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(IDENTIFICADORES_PARA_INSERCION);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<IDENTIFICADORES_PARA_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "VALUES"            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));yybegin(EVALUAR_DATOS_INSERCION);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<EVALUAR_DATOS_INSERCION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "+"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "-"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "*"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "/"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    {FECHA}             {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, AMARILLO, yyline, yycolumn));}
    {CADENA}            {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, VERDE, yyline, yycolumn));}
    "FALSE"             {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    "TRUE"              {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    "<"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    "<="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}

//CREACION LECTURA
<DML_LECTURA>{
    {ESPACIOS}                      {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "*"                             {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "FROM"                          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}                 {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    ";"                             {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    "JOIN"                          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "WHERE"                         {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "GROUP"                         {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ORDER"                         {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "LIMIT"                         {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn)); yybegin(DATO_ENTERO_LIMIT);}
    {SELECCION_COLUMNAS_ID_ID}      {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    ","                             {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "COUNT"                         {añadirToken(new Token(yytext(), TipoToken.FUNCION_AGREGACION, AZUL, yyline, yycolumn)); yybegin(IDENTIFICADOR_FUNCION_AGREGACION);}
    "AVG"                           {añadirToken(new Token(yytext(), TipoToken.FUNCION_AGREGACION, AZUL, yyline, yycolumn)); yybegin(IDENTIFICADOR_FUNCION_AGREGACION);}
    "MAX"                           {añadirToken(new Token(yytext(), TipoToken.FUNCION_AGREGACION, AZUL, yyline, yycolumn)); yybegin(IDENTIFICADOR_FUNCION_AGREGACION);}
    "MIN"                           {añadirToken(new Token(yytext(), TipoToken.FUNCION_AGREGACION, AZUL, yyline, yycolumn)); yybegin(IDENTIFICADOR_FUNCION_AGREGACION);}
    "SUM"                           {añadirToken(new Token(yytext(), TipoToken.FUNCION_AGREGACION, AZUL, yyline, yycolumn)); yybegin(IDENTIFICADOR_FUNCION_AGREGACION);}
    "ON"                            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "="                             {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    {DECIMAL}                       {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    {ENTERO}                        {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {FECHA}                         {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, AMARILLO, yyline, yycolumn));}
    {CADENA}                        {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, VERDE, yyline, yycolumn));}
    "FALSE"                         {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    "TRUE"                          {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    ">"                             {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    "<"                             {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    "<="                            {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">="                            {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    {SIGNOS_LOGICOS}                {añadirToken(new Token(yytext(), TipoToken.LOGICO, NARANJA, yyline, yycolumn));}
    "BY"                            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "DESC"                          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "ASC"                           {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "AS"                            {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "("                             {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                             {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    .                               {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<IDENTIFICADOR_FUNCION_AGREGACION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));yybegin(CERRAR_IDENTIFICADOR_FUNCION_AGREGACION);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<CERRAR_IDENTIFICADOR_FUNCION_AGREGACION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(DML_LECTURA);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<DATO_ENTERO_LIMIT>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));yybegin(DML_LECTURA);}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}

<DML_ACTUALIZACION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    {IDENTIFICADOR}     {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "SET"               {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "="                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    {FECHA}             {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, AMARILLO, yyline, yycolumn));}
    {CADENA}            {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, VERDE, yyline, yycolumn));}
    "FALSE"             {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    "TRUE"              {añadirToken(new Token(yytext(), TipoToken.BOOLEANO, AZUL, yyline, yycolumn));}
    "WHERE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "+"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "-"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "*"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "/"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "<"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    "<="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    {SIGNOS_LOGICOS}    {añadirToken(new Token(yytext(), TipoToken.LOGICO, NARANJA, yyline, yycolumn));}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}
<DML_ELIMINACION>{
    {ESPACIOS}          {añadirToken(new Token(yytext(), TipoToken.ESPACIOS, null, yyline, yycolumn));}
    "FROM"                          {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    {IDENTIFICADOR}                 {añadirToken(new Token(yytext(), TipoToken.IDENTIFICADOR, FUCSIA, yyline, yycolumn));}
    "WHERE"             {añadirToken(new Token(yytext(), TipoToken.CREATE, NARANJA, yyline, yycolumn));}
    "="                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "<"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">"                 {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    "<="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ">="                {añadirToken(new Token(yytext(), TipoToken.RELACIONAL, NEGRO, yyline, yycolumn));}
    ";"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));yybegin(YYINITIAL);}
    ","                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    {ENTERO}            {añadirToken(new Token(yytext(), TipoToken.ENTERO, AZUL, yyline, yycolumn));}
    {DECIMAL}           {añadirToken(new Token(yytext(), TipoToken.DECIMAL, AZUL, yyline, yycolumn));}
    "("                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    ")"                 {añadirToken(new Token(yytext(), TipoToken.SIGNOS, NEGRO, yyline, yycolumn));}
    "+"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "-"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "*"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    "/"                 {añadirToken(new Token(yytext(), TipoToken.ARITMETICO, NEGRO, yyline, yycolumn));}
    .                   {añadirToken(new Token(yytext(), TipoToken.ERROR, yyline, yycolumn));}
}