import 'Filter.dart';

class BadWordsFilter implements Filter {
  final List<String> badWords = ['xxx', 'tonto', 'idiota'];

  @override
  void execute(Map<String, dynamic> request) {
    final title = request['title']?.toString().toLowerCase() ?? '';
    for (var word in badWords) {
      if (title.contains(word)) {
        throw Exception("El título contiene palabras prohibidas: '$word'");
      }
    }
  }
}
