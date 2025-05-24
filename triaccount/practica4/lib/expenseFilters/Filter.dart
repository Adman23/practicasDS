import '../models/expense.dart';

abstract class Filter {
  void execute(Expense expense);
}
