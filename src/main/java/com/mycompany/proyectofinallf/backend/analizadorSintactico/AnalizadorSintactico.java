/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectofinallf.backend.analizadorSintactico;

import com.mycompany.proyectofinallf.backend.Controlador;
import com.mycompany.proyectofinallf.backend.Reportes;
import com.mycompany.proyectofinallf.backend.analizadorLexico.AnalizadorLexicoDB;
import com.mycompany.proyectofinallf.backend.esquema.Table;
import com.mycompany.proyectofinallf.backend.operacion.Operacion;
import com.mycompany.proyectofinallf.backend.token.Token;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author brandon
 */
public class AnalizadorSintactico {

    private List<Token> listaTokens;
    private int posicionToken = 0;
    private List<Token> listaConsultaCorrecta = new ArrayList<>();
    private List<Token> listaTokenErrorSintactico = new ArrayList<>();
    private List<Table> tablasCreadas = new ArrayList<>();
    private List<Operacion> operacionCreate = new ArrayList<>();
    private List<Operacion> operacionDelete = new ArrayList<>();
    private List<Operacion> operacionUpdate = new ArrayList<>();
    private List<Operacion> operacionSelect = new ArrayList<>();
    private List<Operacion> operacionAlter = new ArrayList<>();
    private int numeroOperacion = 1;
    private AnalizadorLexicoDB analizadorLexicoDB;
    private Controlador controlador;

    public AnalizadorSintactico(List<Token> listaTokens, AnalizadorLexicoDB analizadorLexicoDB, Controlador controlador) {
        this.listaTokens = listaTokens;
        this.analizadorLexicoDB = analizadorLexicoDB;
        this.controlador = controlador;
    }

    public void analizar() {
        while (posicionToken < listaTokens.size()) {
            List<Token> estructuraAnalizar = new ArrayList<>();
            for (int i = posicionToken; i < listaTokens.size(); i++) {
                posicionToken++;
                if (listaTokens.get(i).getLexema().equals(";")) {
                    estructuraAnalizar.add(listaTokens.get(i));
                    break;
                } else {
                    estructuraAnalizar.add(listaTokens.get(i));
                }
            }
            saltarEspacios(estructuraAnalizar);
            if (!estructuraAnalizar.isEmpty() && isDDL(estructuraAnalizar)) {
                if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("CREATE")) {
                    listaConsultaCorrecta.add(estructuraAnalizar.get(0));
                    estructuraAnalizar.remove(0);
                    estructuraCreate(estructuraAnalizar);
                } else if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("ALTER")) {
                    System.out.println("IR A FUNCION ALTER");
                } else if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("DROP")) {
                    System.out.println("IR A FUNCION DROP");
                } else {
                    omitirErrorSintactico(estructuraAnalizar, "Se esperaba token: CREATE, ALTER o DROP");
                }
            } else if (isDML(estructuraAnalizar)) {
                if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("INSERT")) {

                } else if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("SELECT")) {

                } else if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("UPDATE")) {

                } else if (!estructuraAnalizar.isEmpty() && estructuraAnalizar.get(0).getLexema().equals("DELETE")) {
                    listaConsultaCorrecta.add(estructuraAnalizar.get(0));
                    estructuraAnalizar.remove(0);
                    saltarEspacios(estructuraAnalizar);
                    estructuraDelete(estructuraAnalizar);
                } else {
                    omitirErrorSintactico(estructuraAnalizar, "Se esperaba una instruccion DDL");
                }
            } else {
                omitirErrorSintactico(estructuraAnalizar, "Se esperaba instuccion DDL o DML");
            }
        }
        Reportes reportes = new Reportes(tablasCreadas, listaTokenErrorSintactico, analizadorLexicoDB.getListaTokensErrores(), operacionCreate, operacionDelete, operacionUpdate, operacionSelect, operacionAlter);
        controlador.setReportes(reportes);
    }

    private boolean isDDL(List<Token> estructuraList) {
        return estructuraList.get(0).getLexema().equals("CREATE") || estructuraList.get(0).getLexema().equals("ALTER")
                || estructuraList.get(0).getLexema().equals("DROP");
    }

    private boolean isDML(List<Token> estructuraList) {
        return estructuraList.get(0).getLexema().equals("INSERT") || estructuraList.get(0).getLexema().equals("SELECT")
                || estructuraList.get(0).getLexema().equals("UPDATE") || estructuraList.get(0).getLexema().equals("DELETE");
    }

    private void omitirErrorSintactico(List<Token> estructuraList, String descripcionError) {
        int tokenErrorGenerado = estructuraList.size();
        while (!estructuraList.isEmpty()) {
            if (estructuraList.size() == tokenErrorGenerado) {
                listaTokenErrorSintactico.add(new Token(estructuraList.get(0).getLexema(), estructuraList.get(0).getTipoToken(),
                        estructuraList.get(0).getFila(), estructuraList.get(0).getColumna(), descripcionError));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
            } else {
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
            }
        }
    }

    private void estructuraCreate(List<Token> estructuraList) {
        saltarEspacios(estructuraList);
        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("DATABASE")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
                System.out.println("Si es un identificador DATABASE");
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && terminarConsulta(estructuraList)) {
                    operacionCreate.add(new Operacion("DDL", numeroOperacion, "CREATE"));
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    numeroOperacion++;
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Faltan estructuras para la consulta");
                } else {
                    omitirErrorSintactico(estructuraList, "ERROR. Se esperaba un ';'");
                }
            } else {
                omitirErrorSintactico(estructuraList, "No es un identificador.");
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("TABLE")) {
            System.out.println("Ir hacia funcion identificador TABLE");
            Table tabla = new Table();
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
                System.out.println("Si es un identificador TABLE");
                tabla.setNombre(estructuraList.get(0).getLexema());
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    do {
                        estructuraDeclaracionTablas(estructuraList, tabla);
                        saltarEspacios(estructuraList);
                    } while (identificador(estructuraList.get(0).getLexema()));
                    if (estructuraList.get(0).getLexema().equals("CONSTRAINT")) {
                        listaConsultaCorrecta.add(estructuraList.get(0));
                        estructuraList.remove(0);
                        saltarEspacios(estructuraList);
                        estructuraLlaves(estructuraList, tabla);
                    } else if (estructuraList.isEmpty()) {
                        omitirErrorSintactico(estructuraList, "ERROR. Vacio");
                    } else {
                        omitirErrorSintactico(estructuraList, "ERROR. Valor esperado: 'CONSTRAINT'");
                    }
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "ERROR. Vacio");
                } else {
                    omitirErrorSintactico(estructuraList, "ERROR. Se esperaba '('");
                }
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "ERROR. Vacio");
            } else {
                omitirErrorSintactico(estructuraList, "No es un identificador.");
            }
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Faltan estructuras para la consulta");
        } else {
            omitirErrorSintactico(estructuraList, "Se esperaba DATABASE O TABLE");
        }
    }

    private boolean terminarConsulta(List<Token> estructuraList) {
        return estructuraList.get(0).getLexema().equals(";");
    }

    public boolean identificador(String texto) {
        // Definir la expresión regular
        String expresionRegular = "^[a-z]+[_(a-z0-9)]*$";

        // Compilar la expresión regular
        Pattern pattern = Pattern.compile(expresionRegular);

        // Crear el matcher para el texto dado
        Matcher matcher = pattern.matcher(texto);

        // Retornar true si encuentra una coincidencia, de lo contrario false
        return matcher.matches();
    }

    private void saltarEspacios(List<Token> estructuraList) {
        if (!estructuraList.isEmpty()) {
            while (estructuraList.get(0).getLexema().equals(" ") || estructuraList.get(0).getLexema().equals("\n")
                    || estructuraList.get(0).getLexema().equals("\t") || estructuraList.get(0).getLexema().equals("\r")
                    || estructuraList.get(0).getLexema().equals("\b")) {
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
            }
        }
    }

    private void estructuraDeclaracionTablas(List<Token> estructuraList, Table tabla) {
        if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
            tabla.getAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            tipoDatoAtributosTabla(estructuraList, tabla);
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Se esperaba un identificador para el atributo");
        } else {
            omitirErrorSintactico(estructuraList, "No es un identificador valido para el atributo");
        }
    }

    private void tipoDatoAtributosTabla(List<Token> estructuraList, Table tabla) {
        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("VARCHAR")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + "(");
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && esNumeroEntero(estructuraList.get(0).getLexema())) {
                    tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + estructuraList.get(0).getLexema());
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                        tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + ")");
                        listaConsultaCorrecta.add(estructuraList.get(0));
                        estructuraList.remove(0);
                        saltarEspacios(estructuraList);
                        atributoNulo(estructuraList, tabla);
                    } else if (estructuraList.isEmpty()) {
                        omitirErrorSintactico(estructuraList, "Vacio");
                    } else {
                        omitirErrorSintactico(estructuraList, "Se esperaba caracter ')'");
                    }
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Se esperaba un numero entero");
                } else {
                    System.out.println("ERROR. El numero ingresado No es entero.");
                }
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("DECIMAL")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + "(");
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && isDecimal(estructuraList.get(0).getLexema())) {
                    tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + estructuraList.get(0).getLexema());
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                        tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + ")");
                        listaConsultaCorrecta.add(estructuraList.get(0));
                        estructuraList.remove(0);
                        saltarEspacios(estructuraList);
                        atributoNulo(estructuraList, tabla);

                    } else if (estructuraList.isEmpty()) {
                        omitirErrorSintactico(estructuraList, "Vacio");
                    } else {
                        omitirErrorSintactico(estructuraList, "Se esperaba caracter ')'");
                    }
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Se esperaba un numero decimal");
                } else {
                    omitirErrorSintactico(estructuraList, "El numero ingresado No es decimal.");
                }
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("NUMERIC")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + "(");
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && isDecimal(estructuraList.get(0).getLexema())) {
                    tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + estructuraList.get(0).getLexema());
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                        tabla.getTipoDatoAtributos().set(tabla.getTipoDatoAtributos().size() - 1, tabla.getTipoDatoAtributos().get(tabla.getTipoDatoAtributos().size() - 1) + ")");
                        listaConsultaCorrecta.add(estructuraList.get(0));
                        estructuraList.remove(0);
                        saltarEspacios(estructuraList);
                        atributoNulo(estructuraList, tabla);
                    } else if (estructuraList.isEmpty()) {
                        omitirErrorSintactico(estructuraList, "Vacio");
                    } else {
                        omitirErrorSintactico(estructuraList, "Se esperaba caracter ')'");
                    }
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Se esperaba un numero entero");
                } else {
                    omitirErrorSintactico(estructuraList, "El numero ingresado No es decimal.");
                }
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("SERIAL")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("INTEGER")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("BIGINT")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("DATE")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("TEXT")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("BOOLEAN")) {
            tabla.getTipoDatoAtributos().add(estructuraList.get(0).getLexema());
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            atributoNulo(estructuraList, tabla);
        } else if (estructuraList.isEmpty()) {
            System.out.println("Vacio");
            omitirErrorSintactico(estructuraList, "Vacio");
        } else {
            omitirErrorSintactico(estructuraList, "Se esperaba alguno de los siguientes valores: 'SERIAL', 'INTEGER', "
                    + "'BIGINT', 'VARCHAR', 'DECIMAL', 'NUMERIC', 'DATE', 'TEXT' o 'BOOLEAN'");
        }
    }

    private void atributoNulo(List<Token> estructuraList, Table tabla) {
        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(",")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("NOT")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("NULL")) {
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(",")) {
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    tabla.setTablaCreada(true);
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Vacio");
                } else {
                    omitirErrorSintactico(estructuraList, "Se esperaba caracter ','");
                }
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "Vacio");
            } else {
                omitirErrorSintactico(estructuraList, "Se esperaba valor 'NULL'");
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("PRIMARY")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("KEY")) {
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(",")) {
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Vacio");
                } else {
                    omitirErrorSintactico(estructuraList, "Se esperaba caracter ','");
                }
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "Vacio");
            } else {
                omitirErrorSintactico(estructuraList, "Se esperaba valor 'KEY'");
            }
        } else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("UNIQUE")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(",")) {
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "Vacio");
            } else {
                omitirErrorSintactico(estructuraList, "Se esperaba caracter ','");
            }
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Vacio");
        } else {
            omitirErrorSintactico(estructuraList, "Se esperaban algunos de los siguientes caracteres: ',', 'NOT', 'PRIMARY' o 'UNIQUE'");
        }
    }

    private boolean esNumeroEntero(String texto) {
        if (texto == null || texto.isEmpty()) {
            return false; // No es un número si es nulo o vacío
        }

        try {
            Integer.parseInt(texto); // Intenta convertir el texto a un entero
            return true; // Si la conversión tiene éxito, es un número entero
        } catch (NumberFormatException e) {
            return false; // Si ocurre una excepción, no es un número entero
        }
    }

    public boolean isDecimal(String texto) {
        // Definir la expresión regular
        String expresionRegular = "^[0-9]+[, (0-9)]*$";

        // Compilar la expresión regular
        Pattern pattern = Pattern.compile(expresionRegular);

        // Crear el matcher para el texto dado
        Matcher matcher = pattern.matcher(texto);

        // Retornar true si encuentra una coincidencia, de lo contrario false
        return matcher.matches();
    }

    private void estructuraLlaves(List<Token> estructuraList, Table tabla) {
        if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            tabla.setLlaveForanea(estructuraList.get(0).getLexema());
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("FOREIGN")) {
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("KEY")) {
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                        listaConsultaCorrecta.add(estructuraList.get(0));
                        estructuraList.remove(0);
                        saltarEspacios(estructuraList);
                        if (!estructuraList.isEmpty() && verificarLlaveForanea(estructuraList, tabla)) {
                            estructuraList.remove(0);
                            saltarEspacios(estructuraList);
                            if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                                this.listaConsultaCorrecta.add(estructuraList.get(0));
                                estructuraList.remove(0);
                                saltarEspacios(estructuraList);
                                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("REFERENCES")) {
                                    listaConsultaCorrecta.add(estructuraList.get(0));
                                    estructuraList.remove(0);
                                    saltarEspacios(estructuraList);
                                    if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
                                        listaConsultaCorrecta.add(estructuraList.get(0));
                                        estructuraList.remove(0);
                                        saltarEspacios(estructuraList);
                                        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("(")) {
                                            listaConsultaCorrecta.add(estructuraList.get(0));
                                            estructuraList.remove(0);
                                            saltarEspacios(estructuraList);
                                            if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
                                                listaConsultaCorrecta.add(estructuraList.get(0));
                                                estructuraList.remove(0);
                                                saltarEspacios(estructuraList);
                                                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                                                    listaConsultaCorrecta.add(estructuraList.get(0));
                                                    estructuraList.remove(0);
                                                    saltarEspacios(estructuraList);
                                                    if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(")")) {
                                                        listaConsultaCorrecta.add(estructuraList.get(0));
                                                        estructuraList.remove(0);
                                                        saltarEspacios(estructuraList);
                                                        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(";")) {
                                                            listaConsultaCorrecta.add(estructuraList.get(0));
                                                            tablasCreadas.add(tabla);
                                                            operacionCreate.add(new Operacion("DDL", numeroOperacion, "CREATE"));
                                                            estructuraList.remove(0);
                                                            saltarEspacios(estructuraList);
                                                        } else if (estructuraList.isEmpty()) {
                                                            omitirErrorSintactico(estructuraList, "Vacio");
                                                        } else {
                                                            omitirErrorSintactico(estructuraList, "Valor esperado ';'");
                                                        }
                                                    } else if (estructuraList.isEmpty()) {
                                                        omitirErrorSintactico(estructuraList, "Vacio");
                                                    } else {
                                                        omitirErrorSintactico(estructuraList, "Valor esperado ')'");
                                                    }
                                                } else if (estructuraList.isEmpty()) {
                                                    omitirErrorSintactico(estructuraList, "Vacio");
                                                } else {
                                                    omitirErrorSintactico(estructuraList, "Valor esperado ')'");
                                                }
                                            } else if (estructuraList.isEmpty()) {
                                                omitirErrorSintactico(estructuraList, "Vacio");
                                            } else {
                                                omitirErrorSintactico(estructuraList, "Cadena no valida para 'Identificador Referencias'");
                                            }
                                        } else if (estructuraList.isEmpty()) {
                                            omitirErrorSintactico(estructuraList, "Vacio");
                                        } else {
                                            omitirErrorSintactico(estructuraList, "Valor esperado: '('");
                                        }
                                    } else if (estructuraList.isEmpty()) {
                                        omitirErrorSintactico(estructuraList, "Vacio");
                                    } else {
                                        omitirErrorSintactico(estructuraList, "Cadena no valida para 'Identificador Referencias'");
                                    }
                                } else if (estructuraList.isEmpty()) {
                                    omitirErrorSintactico(estructuraList, "Vacio");
                                } else {
                                    omitirErrorSintactico(estructuraList, "Valor esperado 'REFERENCES'");
                                }
                            } else if (estructuraList.isEmpty()) {
                                omitirErrorSintactico(estructuraList, "Vacio");
                            } else {
                                omitirErrorSintactico(estructuraList, "Valor esperado ')'");
                            }
                        } else if (estructuraList.isEmpty()) {
                            omitirErrorSintactico(estructuraList, "Vacio");
                        } else {
                            omitirErrorSintactico(estructuraList, "Llaves foranea No coinciden");
                        }
                    } else if (estructuraList.isEmpty()) {
                        omitirErrorSintactico(estructuraList, "Vacio");
                    } else {
                        omitirErrorSintactico(estructuraList, "Valor esperado '('");
                    }
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Vacio");
                } else {
                    omitirErrorSintactico(estructuraList, "Valor esperado 'KEY'");
                }
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "Vacio");
            } else {
                omitirErrorSintactico(estructuraList, "Se esperaba la cadena: 'FOREIGN'");
            }
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Vacio");
        } else {
            omitirErrorSintactico(estructuraList, "ERROR. No es un identificador.");
        }
    }

    private boolean verificarLlaveForanea(List<Token> estructuraList, Table tabla) {
        boolean coincideLlaveForanea = false;
        if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
            for (int i = 0; i < tabla.getAtributos().size(); i++) {
                if (estructuraList.get(0).getLexema().equals(tabla.getAtributos().get(i))) {
                    tabla.setLlaveForanea(tabla.getLlaveForanea() + ": " + tabla.getTipoDatoAtributos().get(i) + " FK");
                    coincideLlaveForanea = true;
                    break;
                }
            }
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Vacio");
        } else {
            omitirErrorSintactico(estructuraList, "ERROR. No es un identificador.");
        }
        return coincideLlaveForanea;
    }

    private void estructuraDelete(List<Token> estructuraList) {
        if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("FROM")) {
            listaConsultaCorrecta.add(estructuraList.get(0));
            estructuraList.remove(0);
            saltarEspacios(estructuraList);
            if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
                Operacion operacionDelete = new Operacion("DELETE", numeroOperacion, estructuraList.get(0).getLexema());
                listaConsultaCorrecta.add(estructuraList.get(0));
                estructuraList.remove(0);
                saltarEspacios(estructuraList);
                if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals("WHERE")) {
                    estructuraWhere(estructuraList, operacionDelete);
                }else if (!estructuraList.isEmpty() && estructuraList.get(0).getLexema().equals(";")) {
                    listaConsultaCorrecta.add(estructuraList.get(0));
                    estructuraList.remove(0);
                    saltarEspacios(estructuraList);
                    this.operacionDelete.add(operacionDelete);
                } else if (estructuraList.isEmpty()) {
                    omitirErrorSintactico(estructuraList, "Valor vacio");
                } else {
                    omitirErrorSintactico(estructuraList, "Se esperaba estructura 'WHERE' o ';' para terminar la instuccion");
                }
            } else if (estructuraList.isEmpty()) {
                omitirErrorSintactico(estructuraList, "Faltan estructuras");
            } else {
                omitirErrorSintactico(estructuraList, "Se esperaba un identificador");
            }
        } else if (estructuraList.isEmpty()) {
            omitirErrorSintactico(estructuraList, "Sin instruccion");
        } else {
            omitirErrorSintactico(estructuraList, "Se esperaba valor 'FROM'");
        }
    }
    
    private void estructuraWhere(List<Token> estructuraList, Operacion operacion){
        if (!estructuraList.isEmpty() && identificador(estructuraList.get(0).getLexema())) {
            
        }else if (true) {
            
        }
    }
    
//    private boolean isDato(){
//        return 
//    }
}
