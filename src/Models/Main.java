package Models;

import Views.FrmLogin;
import Views.FrmMenu;
public class Main {

    public static void main(String[] args) {
        FrmLogin abrir = new FrmLogin();    //  Llamada al formulario inicial
//        FrmMenu abrir = new FrmMenu();
        abrir.setVisible(true);
    }
}
