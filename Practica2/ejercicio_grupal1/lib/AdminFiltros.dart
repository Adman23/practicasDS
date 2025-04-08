import 'CadenaFiltros.dart';
import 'Objetivo.dart';
import 'Filtro.dart';
import 'Correo.dart';


// TODO: Añadir un filtro que sea para controlar si ya está ingresado uno o no
// TODO: Añadir una caja de correos registrados que se pueda acceder desde el main
// TODO: Mostrar los correos con su constraseña en obscure para ver cuales ya están

class AdminFiltros {
  final CadenaFiltros cadenaFiltros;

  AdminFiltros(Objetivo correoFiltro)
      : cadenaFiltros = CadenaFiltros() {
    cadenaFiltros.setObjetivo(correoFiltro);
  }

  void addFiltro(Filtro filtro) {
    cadenaFiltros.addFiltro(filtro);
  }

  MapEntry<bool,String> postCorreo(Correo correo) {
    return cadenaFiltros.ejecutar(correo);
  }
}