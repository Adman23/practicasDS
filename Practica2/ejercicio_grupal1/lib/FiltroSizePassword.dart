import 'Filtro.dart';
import 'Correo.dart';

// La contraseña tiene que tener al menos 8 carácteres
class FiltroSizePassword implements Filtro {
  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool,String> output;
    if (correo.password.length >= 8){
      output = MapEntry(true, "");
    }
    else{
      output = MapEntry(false, "La contraseña tiene que tener 8 o más carácteres");
    }

    return output;
  }
}