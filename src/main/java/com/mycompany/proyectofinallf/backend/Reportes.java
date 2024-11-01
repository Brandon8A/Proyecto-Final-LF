/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend;

import com.mycompany.proyectofinallf.backend.esquema.Table;
import com.mycompany.proyectofinallf.backend.token.Token;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author brandon
 */
public class Reportes {
    
    private List<Table> tablasCreadas;
    private List<Token> listaTokenErrorSintactico;
    private List<Token> listaTokenErrorLexico;

    public Reportes(List<Table> tablasCreadas, List<Token> listaTokenErrorSintactico, List<Token> listaTokenErrorLexico) {
        this.tablasCreadas = tablasCreadas;
        this.listaTokenErrorSintactico = listaTokenErrorSintactico;
        this.listaTokenErrorLexico = listaTokenErrorLexico;
    }

    public List<Table> getTablasCreadas() {
        return tablasCreadas;
    }

    public void setTablasCreadas(List<Table> tablasCreadas) {
        this.tablasCreadas = tablasCreadas;
    }

    public List<Token> getListaTokenErrorSintactico() {
        return listaTokenErrorSintactico;
    }

    public void setListaTokenErrorSintactico(List<Token> listaTokenErrorSintactico) {
        this.listaTokenErrorSintactico = listaTokenErrorSintactico;
    }

    public List<Token> getListaTokenErrorLexico() {
        return listaTokenErrorLexico;
    }

    public void setListaTokenErrorLexico(List<Token> listaTokenErrorLexico) {
        this.listaTokenErrorLexico = listaTokenErrorLexico;
    }
    
    
}
