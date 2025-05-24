import 'user.dart';
class Expense {
  String title;
  double cost;
  DateTime date;
  User buyer;
  Map<User, double> participants;
  String? photo;

  Expense({
    required this.title,
    required this.cost,
    required this.date,
    required this.buyer,
    required this.participants,
    this.photo,
  });
}
