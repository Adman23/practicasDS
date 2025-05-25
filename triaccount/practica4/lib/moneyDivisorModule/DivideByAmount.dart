// DivideByAmount.dart
import 'DivideStrategy.dart';

class DivideByAmount extends DivideStrategy {
  final Map<String, double> userCustomAmounts;

  DivideByAmount(this.userCustomAmounts);

  @override
  Map<String, double> calculateDivision(Map<String, int> participation, double total) {
    final selectedUsers = participation.keys.where((k) => participation[k]! >= 1).toList();

    // Total already manually assigned
    final manuallyAssigned = userCustomAmounts.entries
        .where((e) => selectedUsers.contains(e.key))
        .fold<double>(0.0, (sum, e) => sum + e.value);

    // Users who didn't receive manual assignment
    final autoUsers = selectedUsers
        .where((u) => !userCustomAmounts.containsKey(u))
        .toList();

    final remaining = (total - manuallyAssigned).clamp(0.0, total);
    final share = autoUsers.isEmpty ? 0.0 : remaining / autoUsers.length;

    final result = <String, double>{};
    for (var user in selectedUsers) {
      if (userCustomAmounts.containsKey(user)) {
        result[user] = double.parse(userCustomAmounts[user]!.toStringAsFixed(2));
      } else {
        result[user] = double.parse(share.toStringAsFixed(2));
      }
    }

    return result;
  }
}