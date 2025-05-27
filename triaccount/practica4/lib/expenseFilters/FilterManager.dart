class FilterManager {
  final List<String> _errors = [];

  void addError(String error) {
    _errors.add(error);
  }

  bool hasErrors() => _errors.isNotEmpty;

  List<String> getErrors() => _errors;
}
