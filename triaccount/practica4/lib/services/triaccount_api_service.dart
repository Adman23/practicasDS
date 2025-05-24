import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class TriAccountService {
  final String apiUrl = "http://localhost:3000/api";


  /*
    Esta función es un Future y async porque usa sincronización para conectarse
    a la api de rails, y entonces manda una solicitud post que quiere registrar
    un nuevo usuario y ya está.

    Recibe los parámetros del usuario
   */
  Future<void> registerUser(String username, String email, String password,
                                String passwordConfirmation) async {
    final url = Uri.parse('$apiUrl/users');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'username': username,
            'email': email,
            'password': password,
            'password_confirmation': passwordConfirmation,
          }
        }));

    if (response.statusCode == 201) {
      // Se ha completado bien
    }
    else {
      final data = jsonDecode(response.body);
      final errors = data["errors"];
      throw Exception('Error al registrar el usuario: $errors');
    }
  }

    /*
      Recibe el email y contraseña para inicio de sesión, que hará verificación
      Devuelve el User como objeto ya que será el que se use para luego mostrar
      los grupos.
     */
    Future<User?> login(String email, String password) async {
      final url = Uri.parse('$apiUrl/login');
      final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email':email, 'password':password}));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return User.fromJson(data);
      }
      else{
        final errors = data['errors'];
        throw Exception('Errors: $errors');
      }
    }

}