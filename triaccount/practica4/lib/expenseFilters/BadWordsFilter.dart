import 'Filter.dart';
import 'package:characters/characters.dart';

class BadWordsFilter implements Filter {
  final List<String> badWords = [
    'idiota', 'imbécil', 'tonto', 'estúpido', 'gilipollas',
    'capullo', 'cabrón', 'maldito', 'coño', 'mierda',
    'joder', 'puta', 'puto', 'zorra', 'culero',
    'culera', 'carajo', 'hostia', 'baboso', 'babosa',
    'estúpida', 'gilipuertas', 'pajero', 'mierdoso', 'basura',
    'subnormal', 'malparido', 'malparida', 'cabrona', 'hijo de puta',
    'hija de puta', 'mamón', 'mamona', 'nefasto', 'asqueroso',
    'asquerosa', 'repugnante', 'tarado', 'tarada', 'apestoso',
    'insulso', 'desgraciado', 'desgraciada', 'inútil', 'retrasado',
    'retrasada', 'animal', 'bestia', 'burro', 'burra',
  ];

  // Normaliza el texto reemplazando tildes y símbolos visuales por letras
  String normalizeForFilter(String input) {
    final map = {
      'á': 'a', 'à': 'a', 'ä': 'a', 'â': 'a', 'ã': 'a',
      'é': 'e', 'è': 'e', 'ë': 'e', 'ê': 'e',
      'í': 'i', 'ì': 'i', 'ï': 'i', 'î': 'i',
      'ó': 'o', 'ò': 'o', 'ö': 'o', 'ô': 'o', 'õ': 'o',
      'ú': 'u', 'ù': 'u', 'ü': 'u', 'û': 'u',
      'ñ': 'n',
      '@': 'a', '4': 'a',
      '3': 'e',
      '1': 'i', '!': 'i', '|': 'i',
      '0': 'o', 'º': 'o',
      'v': 'u',
      '5': 's',
      '7': 't',
      '9': 'g',
    };

    final buffer = StringBuffer();

    for (final char in input.toLowerCase().characters) {
      // Si el carácter está en el mapa, lo reemplaza por su valor
      final normalized = map[char] ?? char;
      // Si el carácter es una letra de la a a la z, pasa a la cadena final
      // Si no, se descarta
      // Evita que el usuario introduzca: i.d.i.o.t.a y el filtro lo acepte
      if (RegExp(r'[a-z]').hasMatch(normalized)) {
        buffer.write(normalized);
      }
    }

    return buffer.toString();
  }

  @override
  void execute(Map<String, dynamic> request) {
    final rawTitle = request['title']?.toString() ?? '';
    // Limpia el título para que se pueda comparar con la lista de palabrotas
    final normalizedTitle = normalizeForFilter(rawTitle);
    for (final word in badWords) {
      final normalizedWord = normalizeForFilter(word);
      if (normalizedTitle.contains(normalizedWord)) {
        throw Exception("El título contiene lenguaje ofensivo: '$word'");
      }
    }
  }
}
