import 'DivideStrategy.dart';

// Estrategia que divide un total en partes proporcionales según el valor de participación de cada usuario
class DivideByParts extends DivideStrategy {

  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    // Filtra los usuarios que tienen participación mayor o igual a 1
    final users = participation.entries.where((e) => e.value >= 1).toList();

    // Suma total de las partes (la suma de los valores de participación)
    final totalParts = users.fold<int>(0, (sum, e) => sum + e.value);

    // Si nadie participa (totalParts == 0), devuelve 0.0 para todos los usuarios
    if (totalParts == 0) return { for (var user in participation.keys) user : 0.0 };

    // Calcula cuánto vale una parte del total (redondeado a 2 decimales)
    final partition = double.parse((total / totalParts).toStringAsFixed(2));

    // Devuelve un mapa con cada usuario y lo que debe pagar:
    // cantidad = número de partes * valor de una parte
    return {
      for (var entry in participation.entries)
        entry.key: double.parse((entry.value * partition).toStringAsFixed(2))
    };
  }
}
