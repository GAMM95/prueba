package Controllers;

import Models.CentrarColumnas;
import Models.ColorearLabels;
import Models.ColorearRows;
import Models.Reparto;
import Models.RepartoDAO;
import Views.FrmMenu;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Date;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class RepartoController implements ActionListener {

    //  Atributos de clase
    private Reparto re;
    private RepartoDAO reDAO;
    private FrmMenu frmMenu;

    // Constructor
    public RepartoController(Reparto re, RepartoDAO reDAO, FrmMenu frmMenu) {
        this.re = re;
        this.reDAO = reDAO;
        this.frmMenu = frmMenu;
        interfaces();
        limpiarInputs();
        limpiarMensajesError();
        cargarTabla();
    }

    //  Metodo para implementar interfaces
    private void interfaces() {
        // Eventos ActionListener
        frmMenu.btnRegistrarReparto.addActionListener(this);
        //  Evento KeyListener
    }

    // Metodo para listar datos
    private void cargarTabla() {
        // Vista Usuario
        DefaultTableModel model = (DefaultTableModel) frmMenu.tblRepartoA.getModel();
        int[] anchos = {10, 30, 250, 30, 10};
        model.setRowCount(0);
        for (int i = 0; i < frmMenu.tblRepartoA.getColumnCount(); i++) {
            frmMenu.tblRepartoA.getColumnModel().getColumn(i).setPreferredWidth(anchos[i]);
        }
        frmMenu.tblRepartoA.setDefaultRenderer(Object.class, new CentrarColumnas());  //  Centrado de valores de las columnas
        frmMenu.tblRepartoA.getColumnModel().getColumn(0).setCellRenderer(new ColorearRows(0));
        frmMenu.tblRepartoA.getColumnModel().getColumn(1).setCellRenderer(new ColorearRows(1));
        frmMenu.tblRepartoA.getColumnModel().getColumn(2).setCellRenderer(new ColorearRows(2));
        frmMenu.tblRepartoA.getColumnModel().getColumn(3).setCellRenderer(new ColorearRows(3));
        frmMenu.tblRepartoA.getColumnModel().getColumn(4).setCellRenderer(new ColorearRows(4));
        reDAO.listarRepartoA(model);
    }

    // Metodo para limpiar entradas
    private void limpiarInputs() {
        frmMenu.txtIdTrabajadorReparto.setText("");
        frmMenu.txtTrabajadorAsignadoReparto.setText("");
        frmMenu.txtCargoSeleccionadoReparto.setText("");
        frmMenu.txtCodGuardiaReparto.setText("");
        frmMenu.txtGuardiaSeleccionadaReparto.setText("");
        frmMenu.txtTurnoSeleccionadoReparto.setText("");
        frmMenu.txtCodVehiculoReparto.setText("");
        frmMenu.txtVehiculoSeleccionadoReparto.setText("");
        frmMenu.txtTipoSeleccionadoReparto.setText("");
    }

    // Metodo para limpiar mensajes de error
    private void limpiarMensajesError() {
        frmMenu.mTrabajadorAsignadoReparto.setText("");
        frmMenu.mGuardiaSeleccionadaReparto.setText("");
        frmMenu.mVehiculoSeleccionadoReparto.setText("");
    }

    //  Metodo para validar campos vacios
    private boolean validarCamposVacios() {
        boolean valor = true;   // Valor inicial verdadero
        if (frmMenu.txtTrabajadorAsignadoReparto.getText().isEmpty()) {
            frmMenu.mTrabajadorAsignadoReparto.setText("Seleccione un trabajador");
            frmMenu.mTrabajadorAsignadoReparto.setForeground(Color.red);
            valor = false;
        } else if (frmMenu.txtGuardiaSeleccionadaReparto.getText().isEmpty()) {
            frmMenu.mGuardiaSeleccionadaReparto.setText("Seleccione una guardia");
            frmMenu.mGuardiaSeleccionadaReparto.setForeground(Color.red);
            valor = false;
        } else if (frmMenu.txtVehiculoSeleccionadoReparto.getText().equals("")) {
            frmMenu.mVehiculoSeleccionadoReparto.setText("Seleccione un vehiculo");
            frmMenu.mVehiculoSeleccionadoReparto.setForeground(Color.red);
            valor = false;
        }
        return valor;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource().equals(frmMenu.btnRegistrarReparto)) {
            boolean validarVacios = validarCamposVacios();

            if (validarVacios == false) { // Si los campos estan vacios
                validarCamposVacios();
            } else {
                Date fechaReparto = Date.valueOf(frmMenu.txtFechaReparto.getText());
                int codGuardia = Integer.parseInt(frmMenu.txtCodGuardiaReparto.getText());
                int idTrabajador = Integer.parseInt(frmMenu.txtIdTrabajadorReparto.getText());
                int codVehiculo = Integer.parseInt(frmMenu.txtCodVehiculoReparto.getText());
                String asistencia;
                if (frmMenu.opSi.isSelected()) {
                    asistencia = "Si";
                } else {
                    asistencia = "No";
                }
                re = new Reparto(fechaReparto, asistencia, codGuardia, idTrabajador, codVehiculo);
                if (reDAO.registrarReparto(re)) {
                    cargarTabla();
                    limpiarInputs();
                    JOptionPane.showMessageDialog(null, "Reparto registrado");
                } else {
                    JOptionPane.showMessageDialog(null, "Reparto no registrado");
                }

            }

        }
    }

}
