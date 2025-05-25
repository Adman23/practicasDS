import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/token_service.dart';
import 'user.dart';
import 'expense.dart';

class Group {
  int? id;
  String groupName;
  List<User> users;
  List<Expense> expenses = [];
  Map<String, double> balances = {};
  Map<String, Map<String,double>> refunds = {};
  double totalExpense = 0.0;


  final String apiUrl = "http://localhost:3000/api/groups";

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
      expenses: (json['expenses'] as List<dynamic>? ?? [])
          .map((expenseJson) => Expense.fromJson(expenseJson as Map<String, dynamic>))
          .toList(),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
          .toList(),
      balances: (json['balances'] as Map<String, dynamic>? ?? {})
            .map((key, value) => MapEntry(
            key,
          (value as num).toDouble(),
        )),
      refunds: (json['refunds'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(
            key,
            (value as Map<String, dynamic>? ?? {})
                .map((key,value) => MapEntry(
                  key,
                  (value as num).toDouble()),
          )),
      ),
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /*
    Esta función recibe:
      userEmail  -> String representando el correo del usuario
    Objetivo:
      Se manda solicitud al grupo identificado por su id y a su listado de
      users para añadir un user. No crea un usuario, tiene que existir ya por
      el email (que debería de ser único)
   */
  Future<void> inviteUser(userEmail) async{
    final token = await TokenService().getToken();
    if (token == null) return;

    final url = Uri.parse('$apiUrl/$id/users');
    final response = await http.post(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': userEmail
        })
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200){
      final User newUser = User.fromJson(data['user']);
      final String newKey = data['usernameKey']?.toString() ?? "ERROR";
      users.add(newUser);
      balances[newKey] = 0;
    }
    else{
      final errors = data['error'];
      throw Exception("No se ha podido añadir el usuario: $errors");
    }
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
}