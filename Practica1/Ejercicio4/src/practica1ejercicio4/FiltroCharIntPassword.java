package practica1ejercicio4;

public class FiltroCharIntPassword implements Filtro {
    @Override
    public boolean ejecutar(Correo correo) {
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";
        return correo.getPassword().matches(regex);
    }
}

