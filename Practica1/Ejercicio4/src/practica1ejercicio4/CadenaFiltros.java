package practica1ejercicio4;

import java.util.ArrayList;
import java.util.List;

public class CadenaFiltros implements Filtro {
    private List<Filtro> filtros = new ArrayList<>();
    private Objetivo correoFiltro;

    public void addFiltro(Filtro filtro) {
        filtros.add(filtro);
    }

    public void setObjetivo(Objetivo correoFiltro) {
        this.correoFiltro = correoFiltro;
    }

    @Override
    public boolean ejecutar(Correo correo) {
        for (Filtro filtro : filtros) {
            if (!filtro.ejecutar(correo)) {
                System.out.println("Correo rechazado: " + correo.getEmail());
                return false;
            }
        }

        System.out.println("Correo aceptado: " + correo.getEmail());
        correoFiltro.string(correo);
        return true;
    }
}
