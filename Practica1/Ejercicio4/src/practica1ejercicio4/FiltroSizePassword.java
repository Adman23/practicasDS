package practica1ejercicio4;

public class FiltroSizePassword implements Filtro {
    @Override
    public boolean ejecutar(Correo correo) {
        return correo.getPassword().length() >= 8;
    }
}
