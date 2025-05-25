import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import 'token_service.dart';

class TriAccountService {
  final String apiUrl = "http://localhost:3000/api";


  /*
    Esta función es un Future y async porque usa sincronización para conectarse
    a la api de rails, y entonces manda una solicitud post que quiere registrar
    un nuevo usuario y ya está.

    Recibe los parámetros del usuario
   */
  Future<void> registerUser(String username, String email, String phone,
                    String password, String passwordConfirmation) async {
    final url = Uri.parse('$apiUrl/users');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'username': username,
            'email': email,
            'phone': phone,
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

    /*
      Recibe el email y contraseña para inicio de sesión, que hará verificación
      Devuelve el User como objeto ya que será el que se use para luego mostrar
      los grupos.
     */
    Future<User> login(String email, String password) async {
      final url = Uri.parse('$apiUrl/login');
      final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email':email, 'password':password}));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final String token = data['auth_token'];
        final User user = User.fromJson(data['user']);

        await TokenService().saveToken(token);
        return user;
      }
      else{
        final errors = data['error'];
        throw Exception('Errors: $errors');
      }
    }

  /*
    Recibe el email y contraseña para inicio de sesión, que hará verificación
    Devuelve el User como objeto ya que será el que se use para luego mostrar
    los grupos.
   */
  Future<void> logout() async {
    final token = await TokenService().getToken();
    if (token == null) return;

    final url = Uri.parse('$apiUrl/logout');
    final response = await http.delete(url,
        headers: {'Authorization': token},
    );

    if (response.statusCode == 204) {
      await TokenService().clearToken();
    }
    else{
      throw Exception('Error in logout');
    }
  }

  /// Obtiene todos los usuarios registrados desde la API
  Future<List<User>> fetchUsers() async {
    final token = await TokenService().getToken();
    if (token == null) throw Exception("No auth token");

    final url = Uri.parse('$apiUrl/users');
    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios: ${response.statusCode}');
    }
  }
}