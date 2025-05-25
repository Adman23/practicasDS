// DivideByParts.dart
import 'DivideStrategy.dart';

class DivideByParts extends DivideStrategy {
  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    final users = participation.entries.where((e) => e.value >= 1).toList();
    final totalParts = users.fold<int>(0, (sum, e) => sum + e.value);
    if (totalParts == 0) return { for (var user in participation.keys) user : 0.0 };
    final partition = double.parse((total / totalParts).toStringAsFixed(2));
    return {
      for (var entry in participation.entries)
        entry.key: double.parse((entry.value * partition).toStringAsFixed(2))
    };
  }
}