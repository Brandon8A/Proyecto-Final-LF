/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend;

import java.awt.Color;
import javax.swing.JTextPane;
import javax.swing.text.DefaultStyledDocument;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyleContext;

/**
 *
 * @author brandon
 */
public class PintarPalabras {

    public JTextPane txtPaneCodigoAnalizado;
    private StyleContext styleContext;
    private DefaultStyledDocument document;

    public PintarPalabras() {
        this.txtPaneCodigoAnalizado = new JTextPane();
        this.styleContext = new StyleContext();
        this.document = new DefaultStyledDocument(styleContext);
    }

    public void darEstilo(String textoApintar) {
        txtPaneCodigoAnalizado.setDocument(document);
        try {
            document.insertString(0, textoApintar, null);
        } catch (Exception ex) {
            System.out.println("ERROR: no se pudo establecer estilo de documento");
        }

    }
    
    public void pintarPalabra(int posicionInicial, int posicionFinal, String colorDecode){
        Style color = styleContext.addStyle("ConstantWidth", null);
        StyleConstants.setForeground(color, Color.decode(colorDecode));
        document.setCharacterAttributes(posicionInicial, posicionFinal, color, false);
    }

}
