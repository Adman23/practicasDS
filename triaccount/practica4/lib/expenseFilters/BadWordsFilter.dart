import 'Filter.dart';
import '../models/expense.dart';

class BadWordsFilter implements Filter {
  @override
  void execute(Expense expense) {
    List<String> prohibitedWords = ['silly', 'garbage'];
    String title = expense.title;

    for (var word in prohibitedWords) {
      title = title.replaceAll(word, '[censored]');
    }
    expense.title = title;
  }
}