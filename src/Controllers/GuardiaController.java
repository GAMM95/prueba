package Controllers;

import Models.CentrarColumnas;
import Models.Guardia;
import Models.GuardiaDAO;
import Models.Turno;
import Models.TurnoDAO;
import Models.Validaciones;
import Views.FrmMenu;
import java.awt.Color;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class GuardiaController implements ActionListener, KeyListener, MouseListener {

    //  instancias de clases
    private Turno tur;
    private TurnoDAO turDAO;
    private Guardia gua;
    private GuardiaDAO guaDAO;
    private FrmMenu frmMenu;

    //  Constructor
    public GuardiaController(Turno tur, TurnoDAO turDAO, Guardia gua, GuardiaDAO guaDAO, FrmMenu frmMenu) {
        this.tur = tur;
        this.turDAO = turDAO;
        this.gua = gua;
        this.guaDAO = guaDAO;
        this.frmMenu = frmMenu;
        interfaces();
        cargarTurnos();
        cargarGuardias();
        limpiarInputs();
        limpiarMensajesError();
    }

    //  Interfaces implementadas 
    private void interfaces() {
        //  Eventos ActionListener
        frmMenu.btnSeleccionarTurno.addActionListener(this);
        frmMenu.btnRegistrarGuardia.addActionListener(this);

        //  Eventos KeyListener
        frmMenu.txtNombreGuardia.addKeyListener(this);
        frmMenu.tblTurnos.addKeyListener(this);
        frmMenu.tblGuardias.addKeyListener(this);
    }

    //  Metodo para listar turnos
    private void cargarTurnos() {
        int[] anchos = {8, 30, 30, 30}; //anchos de columnas 
        DefaultTableModel model = (DefaultTableModel) frmMenu.tblTurnos.getModel();
        model.setRowCount(0);
        for (int i = 0; i < frmMenu.tblTurnos.getColumnCount(); i++) {
            frmMenu.tblTurnos.getColumnModel().getColumn(i).setPreferredWidth(anchos[i]);
            frmMenu.tblTurnos.setDefaultRenderer(Object.class, new CentrarColumnas());  //  Centrado de valores de las columnas
        }
        turDAO.listarTurnos(model);
    }

    //  Metodo para cargar guardias
    private void cargarGuardias() {
        int[] anchos = {8, 50, 50, 50, 50}; //anchos de columnas 
        DefaultTableModel model = (DefaultTableModel) frmMenu.tblGuardias.getModel();
        model.setRowCount(0);
        for (int i = 0; i < frmMenu.tblGuardias.getColumnCount(); i++) {
            frmMenu.tblGuardias.getColumnModel().getColumn(i).setPreferredWidth(anchos[i]);
            frmMenu.tblGuardias.setDefaultRenderer(Object.class, new CentrarColumnas());  //  Centrado de valores de las columnas
        }
        guaDAO.listarGuardias(model);
    }

    //  Metodo para limpiar cajas de texto
    private void limpiarInputs() {
        frmMenu.txtCodGuardia.setText("");
        frmMenu.txtNombreGuardia.setText("");
        frmMenu.txtCodTurno.setText("");
        frmMenu.txtTurno.setText("");
        frmMenu.txtHoraEntrada.setText("");
        frmMenu.txtHoraSalida.setText("");
        frmMenu.tblTurnos.clearSelection();
        frmMenu.txtNombreGuardia.requestFocus();
    }

    //  Metodo para limpiar mensajes de error
    private void limpiarMensajesError() {
        frmMenu.mNombreGuardia.setText("");
        frmMenu.mTurno.setText("");
    }

    //  Metodo para validar campos vacios
    private boolean validarCamposVacios() {
        boolean valor = true;
        if (frmMenu.txtNombreGuardia.getText().trim().equals("")) {
            frmMenu.mNombreGuardia.setText("Ingrese nombre de guardia");
            frmMenu.mNombreGuardia.setForeground(Color.red);
            frmMenu.txtNombreGuardia.requestFocus();
            valor = false;
        } else if (frmMenu.txtTurno.getText().isEmpty()) {
            frmMenu.mTurno.setText("Seleccione un turno");
            frmMenu.mTurno.setForeground(Color.red);
            valor = false;
        }
        return valor;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        //  Evento para el boton de seleccion de turno
        if (e.getSource().equals(frmMenu.btnSeleccionarTurno)) {
            int fila = frmMenu.tblTurnos.getSelectedRow();  // Seleccion de fila de la tabla
            //  Obtencion de datos de la tabla
            int codTurno = Integer.parseInt(frmMenu.tblTurnos.getValueAt(fila, 0).toString());
            String nombreTurno = frmMenu.tblTurnos.getValueAt(fila, 1).toString();
            String horaEntrada = frmMenu.tblTurnos.getValueAt(fila, 2).toString();
            String horaSalida = frmMenu.tblTurnos.getValueAt(fila, 3).toString();
            //  Seteo de datos en las entradas
            frmMenu.txtCodTurno.setText(String.valueOf(codTurno));
            frmMenu.txtTurno.setText(nombreTurno);
            frmMenu.txtHoraEntrada.setText(horaEntrada);
            frmMenu.txtHoraSalida.setText(horaSalida);

            // Limpiar mensaje de error
            frmMenu.mTurno.setText("");
        }
        //  Evento para el boton registrar
        if (e.getSource().equals(frmMenu.btnRegistrarGuardia)) {
            //  validar
            boolean validarVacios = validarCamposVacios();

            if (validarVacios == false) { // si los campos estan vacios
                validarCamposVacios();
            } else {
                String nombreGuardia = frmMenu.txtNombreGuardia.getText();
                int codTurno = Integer.parseInt(frmMenu.txtCodTurno.getText());
                gua = new Guardia(nombreGuardia, codTurno);
                if (guaDAO.registrarGuardia(gua) == true) {
                    cargarGuardias();
                    JOptionPane.showMessageDialog(null, "Guardia registrada");
                    limpiarInputs();
                } else {
                    JOptionPane.showMessageDialog(null, "No se registró guardia");
                    limpiarInputs();
                }
            }
        }
    }

    @Override
    public void keyTyped(KeyEvent ke) {
        //  Limiatar tamaño de entrada
        if (ke.getSource().equals(frmMenu.txtNombreGuardia)) {
            Validaciones.soloLetras(ke); // solo letras
            int limite = 15;
            if (frmMenu.txtNombreGuardia.getText().length() == limite) { // si es igual al limite
                ke.consume();
            }
        }
    }

    @Override
    public void keyPressed(KeyEvent ke) {

    }

    @Override
    public void keyReleased(KeyEvent ke) {
        //  Eventos que al escribir contenido en cajas de texto, los mensajes de error se ocultan
        if (ke.getSource().equals(frmMenu.txtNombreGuardia)) {
            frmMenu.mNombreGuardia.setText("");
        }
        //  Evento Limpiar seleccion con Escape despues de clickear tabla
        if (ke.getSource().equals(frmMenu.tblTurnos)) {
            frmMenu.tblTurnos.clearSelection();
        }
        //  Evento de teclas arriba y abajo  para setear datos de la tabla de guardias a los inputs
        if (ke.getSource().equals(frmMenu.tblGuardias)) {
            //  seteo de datos con las flechas arriba y abajo sobre la tabla
            if ((ke.getKeyCode() == KeyEvent.VK_DOWN) || (ke.getKeyCode() == KeyEvent.VK_UP)) {
//                disableButtons();
                int fila = frmMenu.tblGuardias.getSelectedRow();    // seleccionar fila de la tabla
                int codGuardia = Integer.parseInt(frmMenu.tblGuardias.getValueAt(fila, 0).toString());
                frmMenu.txtCodGuardia.setText(String.valueOf(codGuardia)); // Setear codigo de la guardia

                if (!frmMenu.txtCodGuardia.getText().isEmpty()) {
                    int cod = Integer.parseInt(frmMenu.txtCodGuardia.getText());
                    gua = guaDAO.consultarGuardia(cod);
                    // Seteo de datos
                    frmMenu.txtNombreGuardia.setText(gua.getNombreGuardia());
                    frmMenu.txtCodTurno.setText(String.valueOf(gua.getTurno().getCodTurno()));
                    frmMenu.txtTurno.setText(gua.getTurno().getNombreTurno());
                    frmMenu.txtHoraEntrada.setText(gua.getTurno().getHoraEntrada());
                    frmMenu.txtHoraSalida.setText(gua.getTurno().getHoraSalida());
                }
            } else if (ke.getKeyCode() == KeyEvent.VK_ESCAPE) {
                limpiarInputs();
                limpiarMensajesError();
            }
        }

    }

    @Override
    public void mouseClicked(MouseEvent me) {

    }

    @Override
    public void mousePressed(MouseEvent me) {

    }

    @Override
    public void mouseReleased(MouseEvent me) {

    }

    @Override
    public void mouseEntered(MouseEvent me) {

    }

    @Override
    public void mouseExited(MouseEvent me) {

    }

}
