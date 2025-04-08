import 'Filtro.dart';
import 'Correo.dart';

// Filtro que verifica que la contraseña tiene al menos
// Una mayúscula, una minúscula y un número
class FiltroCharIntPassword implements Filtro {
  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool, String> output;
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');

    if (regex.hasMatch(correo.password)){ // En caso de que concuerde
      output = MapEntry(true, "");
    }
    else{
      output = MapEntry(false, "La contraseña tiene que tener mayúsculas, "
          "minúsculas y números");
    }
    return output;
  }
}