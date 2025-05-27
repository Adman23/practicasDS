import 'Filter.dart';
import '../models/expense.dart';
import 'FilterManager.dart';

class BadWordsFilter implements Filter {
  final List<String> _badWords = ['mierda', 'joder', 'puta'];

  @override
  void execute(Expense expense, FilterManager manager) {
    String title = expense.title.toLowerCase();
    for (var word in _badWords) {
      if (title.contains(word)) {
        expense.title = expense.title.replaceAll(RegExp(word, caseSensitive: false), '***');
        manager.addError('El título contenía lenguaje inapropiado y fue censurado.');
      }
    }
  }
}
