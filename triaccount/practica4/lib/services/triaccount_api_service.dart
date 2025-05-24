import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class TriAccountService {
  final String apiUrl = "http://localhost:3000/api";

  Future<User?> registerUser(String username, String email, String password) async {
    final url = Uri.parse('$apiUrl/users');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': {
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': password
        }
      }));

    if (response.statusCode == 201){
      return User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Error al registrar el usuario');
    }
  }
}