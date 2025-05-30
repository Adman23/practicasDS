import 'Filter.dart';

class FilterChain {
  final List<Filter> _filters = [];

  void addFilter(Filter filter) {
    _filters.add(filter);
  }

  void execute(Map<String, dynamic> request) {
    for (final filter in _filters) {
      filter.execute(request);
    }
  }
}
