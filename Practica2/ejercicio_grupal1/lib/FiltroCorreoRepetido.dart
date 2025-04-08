import 'Filtro.dart';
import 'Correo.dart';

// El correo no debe existir ya en el email
class FiltroCorreoRepetido implements Filtro {
  @override
  MapEntry<bool,String> ejecutar(Correo correo) {
    MapEntry<bool,String> output;

    bool encontrado=false;
    List<String> correos = [];

    for (var email in correos) {
      if(correo.email == email){
        encontrado = true;
      }

    }

    if (!encontrado){
      output = MapEntry(true, "");
      correos.add(correo.email);
    }
    else{
      output = MapEntry(false, "El correo es repetido");
    }

    return output;
  }
}