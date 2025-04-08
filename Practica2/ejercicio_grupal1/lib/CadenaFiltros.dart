import 'Filtro.dart';
import 'Objetivo.dart';
import 'Correo.dart';

class CadenaFiltros implements Filtro {
  final List<Filtro> filtros = [];
  late Objetivo correoFiltro;

  void addFiltro(Filtro filtro) {
    filtros.add(filtro);
  }

  void setObjetivo(Objetivo correoFiltro) {
    this.correoFiltro = correoFiltro;
  }

  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool,String> output;

    for (var filtro in filtros) {
      output = filtro.ejecutar(correo);
      if (!output.key) { // En caso de que haya algún correo rechazado
        print("Correo rechazado: ${correo.email}");
        return output;
      }
    }

    print("Correo aceptado: ${correo.email}");
    correoFiltro.string(correo);
    output = MapEntry(true, "Correo y contraseña aceptados");
    return output;
  }
}