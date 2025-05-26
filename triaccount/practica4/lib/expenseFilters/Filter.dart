import '../models/expense.dart'; // Ajusta según tu estructura
import 'FilterManager.dart';

abstract class Filter {
  void execute(Expense expense, FilterManager manager);
}
