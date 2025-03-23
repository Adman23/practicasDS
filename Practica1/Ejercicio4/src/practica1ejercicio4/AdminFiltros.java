package practica1ejercicio4;

public class AdminFiltros {
    private CadenaFiltros cadenaFiltros;
    
    public AdminFiltros(Objetivo correoFiltro){
        cadenaFiltros = new CadenaFiltros();
        cadenaFiltros.setObjetivo(correoFiltro);
    }
    
    public void addFiltro(Filtro filtro){
        cadenaFiltros.addFiltro(filtro);
    }
    
    public void postCorreo(Correo correo){
        cadenaFiltros.ejecutar(correo);
    }
}
