package practica1ejercicio4;

public class Cliente {
    private AdminFiltros admin;
    
    public Cliente(AdminFiltros admin){
        this.admin = admin;
    }
    
    public void enviarCorreo(String email, String password){
        Correo correo = new Correo(email, password);
        admin.postCorreo(correo);
    }
}
