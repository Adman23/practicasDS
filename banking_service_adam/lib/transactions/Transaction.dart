import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Account.dart';
import '../token_service.dart';


abstract class Transaction {
  int? id;
  double amount = 0.0;
  final apiUrl = "http://localhost:3000/accounts";

  Transaction({required this.amount});

  // Recibe la cuenta para aplicar la transacción
  Future<void> apply(Account account);
  Future<void> operate(operation, body, account_id) async{
    final token = await TokenService().getToken();
    if (token == null) throw Exception("No se ha realizado login");

    final url = Uri.parse('$apiUrl/$account_id/transactions/$operation');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json', "Authorization": token},
        body: jsonEncode(body)
    );

    if (response.statusCode == 200){
      // OK
    }
    else{
      final error = jsonDecode(response.body)['error'];
      throw Exception("Error al aplicar transacción: $error");
    }
  }
}