import 'user.dart';

class Expense {
  int? id;
  String title;
  double cost;
  DateTime date;
  User buyer;
  Map<String, double> participants;
  String? photo;
  bool isRefund;

  Expense({
    this.id,
    required this.title,
    required this.cost,
    required this.date,
    required this.buyer,
    required this.participants,
    this.photo,
    this.isRefund=false,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int?,
      title: json['title'] as String,
      cost: (json['cost'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      buyer: User.fromJson(json['buyer']),
      participants: (json['participants'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
        key,
        double.tryParse(value.toString()) ?? 0.0,
      )),
      photo: json['photo'] as String?,
      isRefund: json['is_refund'] ?? false,
    );
  }


  @override
  bool operator == (Object other) =>
      identical(this, other) || // Compara en memoria
          (other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => Object.hash(id,title);

}
