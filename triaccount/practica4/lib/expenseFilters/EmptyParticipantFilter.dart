import 'Filter.dart';
import '../models/expense.dart';
import 'FilterManager.dart';

class EmptyParticipantFilter implements Filter {
  @override
  void execute(Expense expense, FilterManager manager) {
    if (expense.participants == null || expense.participants!.isEmpty) {
      manager.addError('Debe haber al menos un participante en el gasto.');
    }
  }
}
