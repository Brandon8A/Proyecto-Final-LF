/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend;

import com.mycompany.proyectofinallf.backend.esquema.Table;
import com.mycompany.proyectofinallf.backend.operacion.Operacion;
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
    private List<Operacion> operacionCreate = new ArrayList<>();
    private List<Operacion> operacionDelete = new ArrayList<>();
    private List<Operacion> operacionUpdate = new ArrayList<>();
    private List<Operacion> operacionSelect = new ArrayList<>();
    private List<Operacion> operacionAlter = new ArrayList<>();

    public Reportes(List<Table> tablasCreadas, List<Token> listaTokenErrorSintactico, List<Token> listaTokenErrorLexico,
            List<Operacion> operacionCreate, List<Operacion> operacionDelete, List<Operacion> operacionUpdate,List<Operacion> operacionSelect,
            List<Operacion> operacionAlter) {
        this.tablasCreadas = tablasCreadas;
        this.listaTokenErrorSintactico = listaTokenErrorSintactico;
        this.listaTokenErrorLexico = listaTokenErrorLexico;
        this.operacionCreate = operacionCreate;
        this.operacionDelete = operacionDelete;
        this.operacionUpdate = operacionUpdate;
        this.operacionSelect = operacionSelect;
        this.operacionAlter = operacionAlter;
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

    public List<Operacion> getOperacionCreate() {
        return operacionCreate;
    }

    public void setOperacionCreate(List<Operacion> operacionCreate) {
        this.operacionCreate = operacionCreate;
    }

    public List<Operacion> getOperacionDelete() {
        return operacionDelete;
    }

    public void setOperacionDelete(List<Operacion> operacionDelete) {
        this.operacionDelete = operacionDelete;
    }

    public List<Operacion> getOperacionUpdate() {
        return operacionUpdate;
    }

    public void setOperacionUpdate(List<Operacion> operacionUpdate) {
        this.operacionUpdate = operacionUpdate;
    }

    public List<Operacion> getOperacionSelect() {
        return operacionSelect;
    }

    public void setOperacionSelect(List<Operacion> operacionSelect) {
        this.operacionSelect = operacionSelect;
    }

    public List<Operacion> getOperacionAlter() {
        return operacionAlter;
    }

    public void setOperacionAlter(List<Operacion> operacionAlter) {
        this.operacionAlter = operacionAlter;
    }
    
    
}
