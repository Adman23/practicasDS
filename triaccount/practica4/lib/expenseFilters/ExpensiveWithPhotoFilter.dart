import 'Filter.dart';
import '../models/expense.dart';

class ExpensiveWithPhotoFilter implements Filter {
  @override
  void execute(Expense expense) {
    if (expense.cost > 100.0 && (expense.photo == null || expense.photo!.isEmpty)) {
      throw Exception("Expenses over 100€ must include a photo.");
    }
  }
}