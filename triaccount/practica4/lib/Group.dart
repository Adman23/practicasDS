import 'User.dart';
import 'Expense.dart';

class Group {
  String groupName;
  List<User> users = [];
  List<Expense> expenses = [];
  Map<User, double> balances = {};
  List<String> refunds = [];
  double totalExpense = 0.0;

  Group(this.groupName);

  void updateBalance() {
    // Se encarga de realizar la lógica que reparte los gastos de cada usuario.
    // Por ejemplo; si A le debe 15$ a B y B le debe 15$ a C entonces A le deberá 15$ a C.
  }

  void addExpense({required String title, required double cost, required DateTime date, required User buyer, required Map<User, bool> participants, String? photo}) {
    totalExpense += cost;
    // Crear gasto
    Expense expense = Expense(title: title, cost: cost, date: date, buyer: buyer, participants: participants, photo: photo);
    // Añadir gasto a la base de datos
    expenses.add(expense);
  }

  void addUser({required String name}) {
    // Crear usuario
    // Añadir usuario a la base de datos
  }

}