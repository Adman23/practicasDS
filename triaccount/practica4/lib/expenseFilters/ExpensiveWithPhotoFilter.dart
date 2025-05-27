import 'Filter.dart';

class ExpensiveWithPhotoFilter implements Filter {
  final double threshold;

  ExpensiveWithPhotoFilter({this.threshold = 50.0});

  @override
  void execute(Map<String, dynamic> request) {
    final cost = request['cost'] as double? ?? 0.0;
    final image = request['image'];
    if (cost > threshold && (image == null || image.toString().isEmpty)) {
      throw Exception("Los gastos mayores de \$${threshold.toStringAsFixed(2)} requieren una foto.");
    }
  }
}
