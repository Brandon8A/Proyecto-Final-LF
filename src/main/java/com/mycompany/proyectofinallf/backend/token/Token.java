/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend.token;

/**
 *
 * @author brandon
 */
public class Token {
    private String lexema;
    private TipoToken tipoToken;
    private String color;
    private int fila;
    private int columna;
    private String descripcion;

    public Token(String lexema, TipoToken tipoToken, String color, int fila, int columna) {
        this.lexema = lexema;
        this.tipoToken = tipoToken;
        this.color = color;
        this.fila = fila;
        this.columna = columna;
    }

    public Token(String lexema, TipoToken tipoToken, int fila, int columna) {
        this.lexema = lexema;
        this.tipoToken = tipoToken;
        this.fila = fila;
        this.columna = columna;
    }

    public Token(String lexema, TipoToken tipoToken, int fila, int columna, String descripcion) {
        this.lexema = lexema;
        this.tipoToken = tipoToken;
        this.fila = fila;
        this.columna = columna;
        this.descripcion = descripcion;
    }
    

    public String getLexema() {
        return lexema;
    }

    public TipoToken getTipoToken() {
        return tipoToken;
    }

    public String getColor() {
        return color;
    }

    public int getFila() {
        return fila;
    }

    public int getColumna() {
        return columna;
    }

    public String getDescripcion() {
        return descripcion;
    }
    
    
}
