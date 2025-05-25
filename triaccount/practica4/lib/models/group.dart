import 'user.dart';
import 'expense.dart';

class Group {
  int? id;
  String groupName;
  List<User> users = [];
  List<Expense> expenses = [];
  Map<User, double> balances = {};
  List<String> refunds = [];
  double totalExpense = 0.0;

  Group({
    this.id,
    required this.groupName,
    required this.users,
    required this.expenses,
    required this.balances,
    required this.refunds,
    required this.totalExpense
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int?,
      groupName: json['group_name'] as String,
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
          .toList(),
      expenses: (json['expenses'] as List<dynamic>? ?? [])
          .map((expenseJson) => Expense.fromJson(expenseJson as Map<String, dynamic>))
          .toList(),
      balances: (json['balances'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
                User(username: key),
                (value as num).toDouble(),
              )),
      refunds: List<String>.from(json['refunds'] ?? []),
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0.0,
    );
  }

  void updateBalance() {
    // Se encarga de realizar la lógica que reparte los gastos de cada usuario.
    // Por ejemplo; si A le debe 15$ a B y B le debe 15$ a C entonces A le deberá 15$ a C.
  }

  void addExpense({
    required String title,
    required double cost,
    required DateTime date,
    required User buyer,
    required Map<User, double> participants,
    String? photo,
  }) {
    totalExpense += cost;
    Expense expense = Expense(
      title: title,
      cost: cost,
      date: date,
      buyer: buyer,
      participants: participants,
      photo: photo,
    );
    expenses.add(expense);
  }

  void addUser({required String name}) {
    User user = User(username: name);
    users.add(user);
  }
}