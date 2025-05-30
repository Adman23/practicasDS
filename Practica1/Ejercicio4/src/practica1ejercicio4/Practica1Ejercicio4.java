package practica1ejercicio4;

public class Practica1Ejercicio4 {

    public static void main(String[] args) {
        Objetivo correoFiltro = new Objetivo();
        
        AdminFiltros admin = new AdminFiltros(correoFiltro);
        
        //Que tenga algo antes de @ algo y luego de @ gmail.com o hotmail.com
        admin.addFiltro(new FiltroCorreo());
        
        //Que el tamaño de la contraseña sea minimo 8 caracteres
        admin.addFiltro(new FiltroSizePassword());
        
        //Que en la contraseña minimo haya una minuscula, una mayuscula y un numero
        admin.addFiltro(new FiltroCharIntPassword());
        
        //No haya espacion en blanco
        admin.addFiltro(new FiltroBlankPassword());
        
        Cliente correo = new Cliente(admin);
        
        correo.enviarCorreo("ivanMol@gmail.com", "123442W@");
        correo.enviarCorreo("ivanMol@hotmail.com", "Hjkhuh234.");
        correo.enviarCorreo("ivanMol@correo.com", "aa33aA44aafrt");
        correo.enviarCorreo("ivanMol", "12345678iuytrew");
    }
    
}
