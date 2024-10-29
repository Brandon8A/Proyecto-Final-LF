/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package com.mycompany.proyectofinallf.frontend;

import com.mycompany.proyectofinallf.backend.Analizar;
import javax.swing.JTextPane;

/**
 *
 * @author brandon
 */
public class FrameAnalizadorLexico extends javax.swing.JFrame {

    /**
     * Creates new form FrameAnalizadorLexico
     */
    public FrameAnalizadorLexico() {
        initComponents();
        this.setLocationRelativeTo(null);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        tabbedPaneAnalizarCodigo = new javax.swing.JTabbedPane();
        pnlAnalizarCodigo = new javax.swing.JPanel();
        btnAnalizarCodigo = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        txtPaneAnalizarCodigo = new javax.swing.JTextPane();
        pnlCodigoAnalizado = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        txtPaneCodigoAnalizado = new javax.swing.JTextPane();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu2 = new javax.swing.JMenu();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        btnAnalizarCodigo.setText("Analizar");
        btnAnalizarCodigo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnAnalizarCodigoActionPerformed(evt);
            }
        });

        jScrollPane1.setViewportView(txtPaneAnalizarCodigo);

        javax.swing.GroupLayout pnlAnalizarCodigoLayout = new javax.swing.GroupLayout(pnlAnalizarCodigo);
        pnlAnalizarCodigo.setLayout(pnlAnalizarCodigoLayout);
        pnlAnalizarCodigoLayout.setHorizontalGroup(
            pnlAnalizarCodigoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(pnlAnalizarCodigoLayout.createSequentialGroup()
                .addGap(410, 410, 410)
                .addComponent(btnAnalizarCodigo)
                .addContainerGap(420, Short.MAX_VALUE))
            .addGroup(pnlAnalizarCodigoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1))
        );
        pnlAnalizarCodigoLayout.setVerticalGroup(
            pnlAnalizarCodigoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, pnlAnalizarCodigoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 592, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnAnalizarCodigo)
                .addContainerGap())
        );

        tabbedPaneAnalizarCodigo.addTab("Ingresar Codigo", pnlAnalizarCodigo);

        jScrollPane2.setViewportView(txtPaneCodigoAnalizado);

        javax.swing.GroupLayout pnlCodigoAnalizadoLayout = new javax.swing.GroupLayout(pnlCodigoAnalizado);
        pnlCodigoAnalizado.setLayout(pnlCodigoAnalizadoLayout);
        pnlCodigoAnalizadoLayout.setHorizontalGroup(
            pnlCodigoAnalizadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(pnlCodigoAnalizadoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 904, Short.MAX_VALUE)
                .addContainerGap())
        );
        pnlCodigoAnalizadoLayout.setVerticalGroup(
            pnlCodigoAnalizadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(pnlCodigoAnalizadoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 632, Short.MAX_VALUE))
        );

        tabbedPaneAnalizarCodigo.addTab("Codigo Analizado", pnlCodigoAnalizado);

        jMenu1.setText("File");
        jMenuBar1.add(jMenu1);

        jMenu2.setText("Edit");
        jMenuBar1.add(jMenu2);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(tabbedPaneAnalizarCodigo)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(tabbedPaneAnalizarCodigo)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnAnalizarCodigoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnAnalizarCodigoActionPerformed
        // TODO add your handling code here:
        Analizar analizar = new Analizar(txtPaneAnalizarCodigo.getText(), this);
        analizar.analizar();
    }//GEN-LAST:event_btnAnalizarCodigoActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(FrameAnalizadorLexico.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(FrameAnalizadorLexico.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(FrameAnalizadorLexico.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(FrameAnalizadorLexico.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new FrameAnalizadorLexico().setVisible(true);
            }
        });
    }

    public JTextPane getTxtPaneCodigo() {
        return txtPaneAnalizarCodigo;
    }

    public JTextPane getTxtPaneCodigoAnalizado() {
        return txtPaneCodigoAnalizado;
    }

    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnAnalizarCodigo;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JPanel pnlAnalizarCodigo;
    private javax.swing.JPanel pnlCodigoAnalizado;
    private javax.swing.JTabbedPane tabbedPaneAnalizarCodigo;
    private javax.swing.JTextPane txtPaneAnalizarCodigo;
    private javax.swing.JTextPane txtPaneCodigoAnalizado;
    // End of variables declaration//GEN-END:variables
}
