import 'Correo.dart';

abstract class Filtro {
  // Función que devuelve un MapEntry con un bool que indica si se
  // ha superado el filtro o no, en caso de false siempre habrá un mensaje de
  // error adecuado al filtro
  MapEntry<bool,String> ejecutar(Correo correo);
}