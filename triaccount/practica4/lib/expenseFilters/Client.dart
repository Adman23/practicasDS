import 'FilterManager.dart';
import 'FilterChain.dart';
import '../models/expense.dart';
import 'BadWordsFilter.dart';
import 'ExpensiveWithPhotoFilter.dart';
import 'EmptyParticipantFilter.dart';
import 'FutureDateFilter.dart';

class Client {
  final FilterManager manager = FilterManager();
  final FilterChain chain = FilterChain();

  Client() {
    chain.addFilter(BadWordsFilter());
    chain.addFilter(ExpensiveWithPhotoFilter());
    chain.addFilter(EmptyParticipantFilter());
    chain.addFilter(FutureDateFilter());
  }

  bool validateExpense(Expense expense) {
    chain.execute(expense, manager);
    return !manager.hasErrors();
  }

  List<String> getValidationErrors() {
    return manager.getErrors();
  }
}
