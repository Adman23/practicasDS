import './DivideStrategy.dart';

class DivideByParts extends DivideStrategy {

  /*
    Objetivo: División particionada del total, las particiones van de 0
    al número que sea (podría ser un máximo de 10 por ejemplo, ya que lo
    decida la interfaz)
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
    if (calculate){ // Diferencia con la división equitativa, aquí se tiene
                    // en cuenta la participación como tal

      // Calculamos el número de participaciones
      int totalParts = 0;
      for (String user in users){
        totalParts += participation[user]!;
      }

      double partition = double.parse((total / totalParts).toStringAsFixed(2));

      result = participation.map((key,value) => MapEntry(key,
          double.parse((value*partition).toStringAsFixed(2)) ) );
    }

    return result;
  }
}