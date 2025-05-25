// DivideEqually.dart
import 'DivideStrategy.dart';

class DivideEqually extends DivideStrategy {
  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    final users = participation.entries.where((e) => e.value >= 1).map((e) => e.key).toList();
    if (users.isEmpty) return { for (var user in participation.keys) user : 0.0 };
    final partition = double.parse((total / users.length).toStringAsFixed(2));
    return { for (var user in users) user : partition };
  }
}