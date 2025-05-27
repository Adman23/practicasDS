import 'Filter.dart';

class FutureDateFilter implements Filter {
  @override
  void execute(Map<String, dynamic> request) {
    final date = request['date'] as DateTime?;
    if (date != null && date.isAfter(DateTime.now())) {
      throw Exception("No se pueden registrar gastos con fecha futura.");
    }
  }
}
