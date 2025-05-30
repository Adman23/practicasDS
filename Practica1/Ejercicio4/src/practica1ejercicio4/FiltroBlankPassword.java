package practica1ejercicio4;

public class FiltroBlankPassword implements Filtro {
    @Override
    public boolean ejecutar(Correo correo) {
        return !correo.getPassword().contains(" ");
    }
}
