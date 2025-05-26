import 'Filter.dart';
import '../models/expense.dart';
import 'FilterManager.dart';

class FutureDateFilter implements Filter {
  @override
  void execute(Expense expense, FilterManager manager) {
    if (expense.date.isAfter(DateTime.now())) {
      manager.addError('La fecha del gasto no puede estar en el futuro.');
    }
  }
}
