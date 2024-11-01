/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend.operacion;

/**
 *
 * @author brandon
 */
public class Operacion {

    private String tipoOperacion;
    private int numero;
    private String seccion;

    public Operacion(String tipoOperacion, int numero, String seccion) {
        this.tipoOperacion = tipoOperacion;
        this.numero = numero;
        this.seccion = seccion;
    }

    public String getTipoOperacion() {
        return tipoOperacion;
    }

    public int getNumero() {
        return numero;
    }

    public String getSeccion() {
        return seccion;
    }

    

}
