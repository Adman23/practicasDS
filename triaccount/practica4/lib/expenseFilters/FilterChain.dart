import 'Filter.dart';
import '../models/expense.dart';
import 'FilterManager.dart';

class FilterChain {
  final List<Filter> _filters = [];

  void addFilter(Filter filter) {
    _filters.add(filter);
  }

  void execute(Expense expense, FilterManager manager) {
    for (var filter in _filters) {
      filter.execute(expense, manager);
    }
  }
}
