import './DivideStrategy.dart';

class DivideEqually extends DivideStrategy {

  /*
    Objetivo: División equitativa del total según la participación, que puede
    ser o 0 o 1, dependiendo de si participan o no
   */
  @override
  Map<String,double> calculateDivision(Map<String,int> participation, double total){
    // Nuestro mapa resultado con las mismas keys
    Map<String, double> result =
    participation.map((key,value) => MapEntry(key, 0.0));

    // Comprobación previa de que las participaciones son correctas, en caso
    // de que sean todas 0, simplemente se devuelve el Map con coste 0 para todos
    // En la interfaz se hará verificación de que el total se está dividiendo.
    bool calculate = false;

    List<String> users = participation.entries
        .where((entry) => entry.value >= 1)
        .map((entry) => entry.key)
        .toList();

    if (users.isNotEmpty){
      calculate = true;
    }

    // Cuerpo
    if (calculate){
      double partition = double.parse((total / users.length).toStringAsFixed(2));
      result = { for (var u in users) u : partition };
    }

    return result;
  }
}