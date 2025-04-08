import 'Filtro.dart';
import 'Correo.dart';

class FiltroBlankPassword implements Filtro {
  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool, String> output; // Sirve para controlar si ha fallado
    if (!correo.password.contains(" ")){
      output = MapEntry(true, ""); // Si no contiene espacio pasa el filtro
    }
    else{
      output = MapEntry(false, "La contraseña NO puede "
                              "tener espacios en blanco");
    }
    return output;
  }
}