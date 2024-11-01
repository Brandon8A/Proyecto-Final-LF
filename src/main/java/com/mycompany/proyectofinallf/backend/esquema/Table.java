/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend.esquema;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author brandon
 */
public class Table {
    private String nombre;
    private String llavePrimaria;
    private String atributoUnico;
    private String llaveForanea;
    private List<String> atributos = new ArrayList<>();
    private List<String> tipoDatoAtributos = new ArrayList<>();
    private boolean tablaCreada;

    public Table() {
    }

    public String getNombre() {
        return nombre;
    }

    public String getLlavePrimaria() {
        return llavePrimaria;
    }

    public String getAtributoUnico() {
        return atributoUnico;
    }

    public String getLlaveForanea() {
        return llaveForanea;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setLlavePrimaria(String llavePrimaria) {
        this.llavePrimaria = llavePrimaria;
    }

    public void setAtributoUnico(String atributoUnico) {
        this.atributoUnico = atributoUnico;
    }

    public void setLlaveForanea(String llaveForanea) {
        this.llaveForanea = llaveForanea;
    }

    public List<String> getAtributos() {
        return atributos;
    }

    public void setAtributos(List<String> atributos) {
        this.atributos = atributos;
    }

    public List<String> getTipoDatoAtributos() {
        return tipoDatoAtributos;
    }

    public void setTipoDatoAtributos(List<String> tipoDatoAtributos) {
        this.tipoDatoAtributos = tipoDatoAtributos;
    }

    public boolean isTablaCreada() {
        return tablaCreada;
    }

    public void setTablaCreada(boolean tablaCreada) {
        this.tablaCreada = tablaCreada;
    }
    
    
}
