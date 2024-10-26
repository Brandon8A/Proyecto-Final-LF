/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend;

import com.mycompany.proyectofinallf.backend.analizadorLexico.AnalizadorLexicoDB;
import java.io.IOException;
import java.io.StringReader;

/**
 *
 * @author brandon
 */
public class Analizar {

    private String entrada;

    public Analizar(String entrada) {
        this.entrada = entrada;
    }

    public void analizar() {
        AnalizadorLexicoDB analizadorLexicoDB = new AnalizadorLexicoDB(new StringReader(entrada));
        try {
            while (analizadorLexicoDB.yylex() != AnalizadorLexicoDB.YYEOF) {
                analizadorLexicoDB.yylex();
            }
        } catch (IOException ex) {
            ex.getStackTrace();
        }
    }
}
