import 'Filter.dart';
import '../models/expense.dart';
import 'FilterManager.dart';

class ExpensiveWithPhotoFilter implements Filter {
  static const double expensiveThreshold = 100.0;

  @override
  void execute(Expense expense, FilterManager manager) {
    if (expense.cost > expensiveThreshold && (expense.photo == null || expense.photo!.isEmpty)) {
      manager.addError('Gastos mayores de 100€ requieren incluir una foto como comprobante.');
    }
  }
}
