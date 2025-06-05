import 'dart:convert';
import 'package:banking_service_adam/token_service.dart';
import 'package:http/http.dart' as http;
import 'transactions/Transaction.dart';
import 'transactions/WithdrawalTransaction.dart';
import 'transactions/DepositTransaction.dart';
import 'transactions/TransferTransaction.dart';
import './Account.dart';


class BankService {
  Map<String, Account> accounts = {};
  final apiUrl = "http://localhost:3000";

  //----------------------------------------------------------------------------
  // Función para el registro
  Future<void> registerUser(String name, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse('$apiUrl/users');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'name': name,
            'email_address': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
          }
        }));

    if (response.statusCode == 201) {
      // Se ha completado bien
    }
    else {
      final data = jsonDecode(response.body);
      final errors = data["error"];
      throw Exception('Error al registrar el usuario: $errors');
    }
  }

  // Función para el logeo
  Future<String> login(String email, String password) async {
    final url = Uri.parse('$apiUrl/login');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_address': email,
          'password': password,
        }));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = data['token'];
      await TokenService().saveToken(token);
      try {
        await getAccounts();
      }
      catch (e) {
        rethrow;
      }
      return data['username'];
    }
    else{
      final errors = data['errors'];
      throw Exception('Errors: $errors');
    }
  }

  // Manda el token a ver si sigue autorizado
  Future<String> checkLogin() async {
    final token = await TokenService().getToken();
    if (token == null) return "";

    final url = Uri.parse('$apiUrl/check');
    final response = await http.get(url,
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      try {
        await getAccounts();
      }
      catch (e){
        rethrow;
      }
      return jsonDecode(response.body)['username'];
    }
    return "";
  }

  // Función para el logout del usuario activo
  Future<void> logout() async {
    final token = await TokenService().getToken();
    if (token == null) return;

    final url = Uri.parse('$apiUrl/logout');
    final response = await http.delete(url,
      headers: {'Authorization': token},
    );

    accounts.clear();
    await TokenService().clearToken();
  }

  Future<Account> createAccount() async {
    final token = await TokenService().getToken();
    if (token == null) throw Exception("No se ha realizado login");

    final url = Uri.parse('$apiUrl/accounts');
    final response = await http.post(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201){
      // Se ha creado bien
      Account nueva = Account.fromJson(jsonDecode(response.body));
      accounts[nueva.number] = nueva;
      return nueva;
    }
    else{
      final errors = jsonDecode(response.body)['errors'];
      throw Exception("Error al crear cuenta: $errors");
    }
  }

  Future<void> getAccounts() async {
    final token = await TokenService().getToken();
    if (token == null) throw Exception("No se ha realizado login");

    final url = Uri.parse('$apiUrl/accounts');
    final response = await http.get(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200){
      // Se ha creado bien
      final data = jsonDecode(response.body);
      for (var account in data){
        accounts[account['number']] = Account.fromJson(account);
      }
    }
    else{
      final errors = jsonDecode(response.body)['errors'];
      throw Exception("Error al crear cuenta: $errors");
    }
  }

  //----------------------------------------------------------------------------


  Future<void> deposit(String accountNum, double amount) async {
    Transaction deposit = DepositTransaction(amount: amount);
    await deposit.apply(accounts[accountNum]!);
  }

  Future<void> withdraw(String accountNum, double amount) async {
    Transaction withdrawal = WithdrawalTransaction(amount: amount);
    await withdrawal.apply(accounts[accountNum]!);
  }

  Future<void> transfer(String accountNumFrom, String accountNumTo, double amount) async {
    Transaction transfer = TransferTransaction(amount: amount, toAccount: accounts[accountNumTo]!);
    await transfer.apply(accounts[accountNumFrom]!);
  }

  double getBalance(String accountNum){
    return accounts[accountNum]!.balance;
  }
}
