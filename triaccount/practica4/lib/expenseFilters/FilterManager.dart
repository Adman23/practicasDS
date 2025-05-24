import 'package:triaccount/models/expense.dart';

import 'FilterChain.dart';
import 'Target.dart';
import 'Filter.dart';
class FilterManager {
  late FilterChain filterChain;

  FilterManager(Target target) {
    filterChain = FilterChain();
    filterChain.setTarget(target);
  }

  void addFilter(Filter filter) {
    filterChain.addFilter(filter);
  }

  void publish(Expense expense) {
    filterChain.execute(expense);
  }
}