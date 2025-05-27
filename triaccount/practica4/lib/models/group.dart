import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../services/token_service.dart';
import 'user.dart';
import 'expense.dart';
import '../expenseFilters/FilterManager.dart';
import '../expenseFilters/BadWordsFilter.dart';
import '../expenseFilters/EmptyParticipantFilter.dart';
import '../expenseFilters/ExpensiveWithPhotoFilter.dart';
import '../expenseFilters/FutureDateFilter.dart';


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
    // Manejar refunds
    final refundsMap = json['refunds'] as Map<String, dynamic>? ?? {};
    final refunds = refundsMap.map((key, value) {
      final innerMap = <String, double>{};

      if (value is Map) {
        value.forEach((subKey, subValue) {
          innerMap[subKey.toString()] = double.tryParse(subValue.toString()) ?? 0.0;
        });
      }

      return MapEntry(key, innerMap);
    });


    return Group(
      id: int.tryParse(json['id'].toString()),
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
            double.tryParse(value.toString()) ?? 0.0,
        )),
      refunds: refunds,
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
      refunds[newKey] = {};
      updateGroupDB();
    }
    else{
      final errors = data['error'];
      throw Exception("No se ha podido añadir el usuario: $errors");
    }
  }

  Future<void> removeUser(username) async{
    final token = await TokenService().getToken();
    if (token == null) return;

    // Obtenemos el id, el nombre puede ser o username normal
    // o username_email
    List<String> parts = username.split('_');
    User chosen;
    if (parts.length > 1){
      String userEmail = parts[1];
      chosen = users.firstWhere((user) => user.email == userEmail);
    }
    else{
      chosen = users.firstWhere((user) => user.username == username);
    }

    int user_id = chosen.id!;

    final url = Uri.parse('$apiUrl/$id/users/$user_id');
    final response = await http.delete(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'}
    );

    if (response.statusCode == 204){
      users.remove(chosen);
      balances.remove(username);
      refunds.remove(username);
      updateGroupDB();
    }
    else{
      final data = jsonDecode(response.body);
      final errors = data['error'];
      throw Exception("No se ha podido añadir el usuario: $errors");
    }
  }



  /*
    Actualiza tanto los balances como los refunds con el nuevo gastupdateGroupDBo
    Funcionamiento:
      Al buyer se le pone en los balances como +cost
      A cada uno de los participantes se le pone a los balances -part
      Recordar que si un username se repite se pondrá como username_email
      si luego se pasa a crear el expense es importante que en participants
      este definido de la misma forma así se puede buscar.

      Al buyer esto no le pasará por lo que se tiene que comprobar primero
      usernam_email y luego username para verificarlo, ya que los expenses
      simplemente tienen uno que paga y luego ya el participants para mostrarlo
   */
  void updateBalance(Expense ex, User buyer) {
    // Se encarga de realizar la lógica que reparte los gastos de cada usuario.
    // Por ejemplo; si A le debe 15$ a B y B le debe 15$ a C entonces A le deberá 15$ a C.

    // Actualizamos el buyer
    if (balances.keys.contains("${buyer.username}_${buyer.email}")){
      balances["${buyer.username}_${buyer.email}"] =
          balances["${buyer.username}_${buyer.email}"]! + ex.cost;
    }
    else {
        balances["${buyer.username}"] =
            balances["${buyer.username}"]! + ex.cost;
    }

    ex.participants.forEach((key, value){
      balances[key] = balances[key]! - value;
    });


    // RECALCULAMOS las posibles devoluciones
    // Para ello separamos quien está positivo en balances y quien está negativo
    final List<MapEntry<String, double>> positive = [];
    final List<MapEntry<String, double>> negative = [];
    refunds = <String, Map<String, double>>{};

    // Se mete cada uno en su mapa apropiado
    balances.forEach((name, amount) {
      if (amount > 0) {
        positive.add(MapEntry(name, amount));
      } else if (amount < 0) {
        negative.add(MapEntry(name, amount.abs()));
      }
      refunds[name] = {};
    });

    // Se asigna las mismas keys que hay en balances positivos
    // Ya que serán los que reciben

    /*
      Se van cogiendo los minimos entre cada uno de los positivos y de los
      negativos, por ejemplo, si ahora se coge el primer negativo y el primer
      positivo se mirará el minimo, si es el positivo se resta al negativo
      esa cantidad y se pondrá en el reembolso esa misma cantidad, y como
      ahora es 0 el value de positive[i] se pasa al siguiente y así.
     */
    int i = 0;
    int j = 0;
    while (i < positive.length && j < negative.length) {
      final pos = positive[i];
      final neg = negative[j];

      final namePos = pos.key;
      final nameNeg = neg.key;

      final amount = min(pos.value, neg.value);

      refunds[nameNeg]?[namePos] = amount;

      positive[i] = MapEntry(namePos, pos.value - amount);
      negative[j] = MapEntry(nameNeg, neg.value - amount);

      if (positive[i].value <= 0) i++;
      if (negative[j].value <= 0) j++;
    }
  }


  Future<void> updateGroupDB() async {
    final token = await TokenService().getToken();
    if (token == null) throw  Exception("No hay sesion");

    final url = Uri.parse('$apiUrl/$id');
    final response = await http.patch(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'},
        body: jsonEncode({
          'group': {
            'balances': balances,
            'refunds': refunds,
            'total_expense': totalExpense,
          }
        }));

    if (response.statusCode == 204){
      // BIEN
    }
    else{
      final data = jsonDecode(response.body);
      final errors = data['errors'];
      throw Exception("Error al modificar el grupo : $errors");
    }
  }


  Future<void> removeExpense(Expense ex) async{
    final token = await TokenService().getToken();
    if (token == null) return;

    final url = Uri.parse('$apiUrl/$id/expenses/${ex.id}');
    final response = await http.delete(url,
        headers: {'Authorization': token,
        'Content-Type': 'application/json'});

    if (response.statusCode == 204){
      ex.cost = -ex.cost;
      ex.participants.forEach((key,value) {
        ex.participants[key] = -value;
      });
      updateBalance(ex, ex.buyer);
      expenses.remove(ex);
      if (!ex.isRefund) {
        totalExpense += ex.cost;
      }
      updateGroupDB();
    }
    else{
      final data = jsonDecode(response.body);
      final errors = data['errors'];
      throw Exception("No se ha podido eliminar el gasto: $errors");
    }
  }


  Future<Expense> addExpense(
      String title,
      double cost,
      DateTime date,
      String buyer,
      Map<String, double> participants,
      bool isRefund,
      String? photo,
      ) async {
    final token = await TokenService().getToken();
    if (token == null) return Expense.fromJson({});

    List<String> parts = buyer.split('_');
    User chosen;
    if (parts.length > 1){
      String userEmail = parts[1];
      chosen = users.firstWhere((user) => user.email == userEmail);
    }
    else{
      chosen = users.firstWhere((user) => user.username == buyer);
    }

    // Aplicar los filtros antes de enviar al backend
    final request = {
      'title': title,
      'cost': cost,
      'date': date,
      'buyer': buyer,
      'participants': participants,
      'image': photo,
      'is_refund': isRefund,
    };

    final filterManager = FilterManager()
      ..addFilter(BadWordsFilter())
      ..addFilter(EmptyParticipantFilter())
      ..addFilter(FutureDateFilter())
      ..addFilter(ExpensiveWithPhotoFilter());

    try {
      filterManager.filterRequest(request);
    } catch (e) {
      throw Exception("Error de validación al añadir gasto: ${e.toString()}");
    }

    final url = Uri.parse('$apiUrl/$id/expenses');
    final response = await http.post(url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'expense': {
            'title': title,
            'cost': cost,
            'date': date.toIso8601String(),
            'buyer_id': chosen.id,
            'participants': participants,
            'image': photo,
            'is_refund': isRefund,
          }
        })
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201){
      Expense nuevo = Expense.fromJson(data);
      if (!nuevo.isRefund) {
        totalExpense += nuevo.cost;
      }
      expenses.insert(0, nuevo);
      updateBalance(nuevo, chosen);
      updateGroupDB();
      return nuevo;
    } else {
      final errors = data['errors'];
      throw Exception("Error al añadir gasto: $errors");
    }
  }
}