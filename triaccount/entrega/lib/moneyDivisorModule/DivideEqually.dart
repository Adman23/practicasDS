import 'DivideStrategy.dart';

// Estrategia que divide el total en partes iguales entre todos los usuarios que participan
class DivideEqually extends DivideStrategy {

  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    // Filtra los usuarios que tienen participación >= 1
    final users = participation.entries.where((e) => e.value >= 1).map((e) => e.key).toList();

    // Si no hay ningún usuario con participación válida, devuelve 0.0 para todos
    if (users.isEmpty) return { for (var user in participation.keys) user : 0.0 };

    // Calcula cuánto le corresponde a cada usuario (total dividido entre participantes)
    final partition = double.parse((total / users.length).toStringAsFixed(2));

    // Crea y devuelve un mapa con cada usuario y su parte igual del total
    return { for (var user in users) user : partition };
  }
}
