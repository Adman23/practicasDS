import 'Filtro.dart';
import 'Correo.dart';

class FiltroCorreo implements Filtro {
  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool, String> output;
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@(?:gmail|hotmail)\.com$');

    if (regex.hasMatch(correo.email)) { // En caso de que el correo haga match
      output = MapEntry(true, "");
    }
    else{
      output = MapEntry(false, "Correo debe de tener la estructura: "
          "(letra o número)@gmail|hotmail.com");
    }
    return output;
  }
}