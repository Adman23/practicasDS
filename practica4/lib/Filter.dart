import 'Expense.dart';

abstract class Filter {
  void execute(Expense expense);
}
