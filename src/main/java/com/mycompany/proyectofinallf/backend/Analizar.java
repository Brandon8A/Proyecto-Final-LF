/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend;

import com.mycompany.proyectofinallf.backend.analizadorLexico.AnalizadorLexicoDB;
import com.mycompany.proyectofinallf.backend.token.Token;
import com.mycompany.proyectofinallf.frontend.FrameAnalizadorLexico;
import java.io.IOException;
import java.io.StringReader;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author brandon
 */
public class Analizar {

    private String entrada;
    private List<Token> listaTokens;
    private AnalizadorLexicoDB analizadorLexicoDB;
    private FrameAnalizadorLexico frameAnalizadorLexico;

    public Analizar(String entrada, FrameAnalizadorLexico frameAnalizadorLexico) {
        this.entrada = entrada;
        this.frameAnalizadorLexico = frameAnalizadorLexico;
    }

    public void analizar() {
        frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setText("");
        analizadorLexicoDB = new AnalizadorLexicoDB(new StringReader(entrada));
//        try {
//            while(analizadorLexicoDB.yylex() != AnalizadorLexicoDB.YYEOF){
//                analizadorLexicoDB.yylex();
//            }
//        } catch (IOException ex) {
//            Logger.getLogger(Analizar.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        analizadorLexicoDB.pintar.darEstilo(frameAnalizadorLexico.getTxtPaneCodigo().getText());
//        frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setDocument(analizadorLexicoDB.pintar.txtPaneCodigoAnalizado.getDocument());
        try {
            analizadorLexicoDB.yylex();
        } catch (IOException ex) {
            Logger.getLogger(Analizar.class.getName()).log(Level.SEVERE, null, ex);
        }
        listaTokens = analizadorLexicoDB.getListaTokens();
        frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setText("");
        for (int i = listaTokens.size()-1; 0 <= i; i--) {
            System.out.println("TOKEN --> "+listaTokens.get(i).getLexema());
            analizadorLexicoDB.pintar.darEstilo(listaTokens.get(i).getLexema());
            if (listaTokens.get(i).getColor() != null) {
                analizadorLexicoDB.pintar.pintarPalabra(0, listaTokens.get(i).getLexema().length(), listaTokens.get(i).getColor());
            }
            frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setDocument(analizadorLexicoDB.pintar.txtPaneCodigoAnalizado.getDocument());
//            if (i == 0) {
//                frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setText(frameAnalizadorLexico.getTxtPaneCodigoAnalizado().getText() + listaTokens.get(i).getLexema());
//            }else{
//                frameAnalizadorLexico.getTxtPaneCodigoAnalizado().setText(frameAnalizadorLexico.getTxtPaneCodigoAnalizado().getText() + " " +listaTokens.get(i).getLexema());
//            }
        }
    }

}
