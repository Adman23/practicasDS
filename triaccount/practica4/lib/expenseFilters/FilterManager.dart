import 'FilterChain.dart';
import 'Filter.dart';

class FilterManager {
  final FilterChain _filterChain = FilterChain();

  void addFilter(Filter filter) {
    _filterChain.addFilter(filter);
  }

  void filterRequest(Map<String, dynamic> request) {
    _filterChain.execute(request); // Ejecuta todos los filtros en orden
  }
}
