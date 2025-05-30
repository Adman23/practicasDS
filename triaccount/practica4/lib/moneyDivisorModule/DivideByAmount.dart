import 'DivideStrategy.dart';

// Esta clase representa una estrategia de división donde algunos usuarios tienen cantidades asignadas manualmente
class DivideByAmount extends DivideStrategy {
  // Mapa de usuarios con la cantidad que deben pagar manualmente asignada
  final Map<String, double> userCustomAmounts;

  DivideByAmount(this.userCustomAmounts);

  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    // Filtra los usuarios que participan en el gasto (participación >= 1)
    final selectedUsers = participation.keys.where((k) => participation[k]! >= 1).toList();

    // Suma cuánto se ha asignado manualmente entre los usuarios seleccionados
    final manuallyAssigned = userCustomAmounts.entries
        .where((e) => selectedUsers.contains(e.key)) // Solo considera los que participan
        .fold<double>(0.0, (sum, e) => sum + e.value); // Suma todas las asignaciones manuales

    // Lista de usuarios que no tienen cantidad asignada manualmente (se les reparte lo restante)
    final autoUsers = selectedUsers
        .where((u) => !userCustomAmounts.containsKey(u))
        .toList();

    // Calcula lo que queda por repartir después de las asignaciones manuales.
    // Se asegura de que esté entre 0 y el total, evitando valores negativos
    final remaining = (total - manuallyAssigned).clamp(0.0, total);

    // Divide el restante equitativamente entre los usuarios sin asignación manual
    final share = autoUsers.isEmpty ? 0.0 : remaining / autoUsers.length;

    // Construye el mapa final con la cantidad que debe pagar cada usuario
    final result = <String, double>{};
    for (var user in selectedUsers) {
      if (userCustomAmounts.containsKey(user)) {
        // Si el usuario tiene asignación manual, se utiliza esa cantidad (redondeada a 2 decimales)
        result[user] = double.parse(userCustomAmounts[user]!.toStringAsFixed(2));
      } else {
        // Si no tiene asignación, se le asigna su parte del restante (también redondeado)
        result[user] = double.parse(share.toStringAsFixed(2));
      }
    }

    // Devuelve el resultado final de la división
    return result;
  }
}
