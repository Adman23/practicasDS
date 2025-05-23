import 'Target.dart';
import '../Expense.dart';
import 'Filter.dart';

class FilterChain implements Filter {
  final List<Filter> filters = [];
  late Target expenseTarget;

  void addFilter(Filter filter) {
    filters.add(filter);
  }

  void setTarget(Target expenseTarget) {
    this.expenseTarget = expenseTarget;
  }

  @override
  void execute(Expense expense) {
    for (var filter in filters) {
      filter.execute(expense);
    }
    expenseTarget.publish(expense);
  }
}
