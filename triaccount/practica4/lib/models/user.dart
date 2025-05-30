
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/token_service.dart';
import 'group.dart';

class User{
  int? id;
  String? username;
  String? email;
  String? phone;

  final String apiUrl = "http://localhost:3000/api/users";


  User({ this.id, this.username, this.email, this.phone});


  @override
  bool operator == (Object other) =>
    identical(this, other) || // Compara en memoria
    (other is User &&
    runtimeType == other.runtimeType &&
    id == other.id && email == other.email);

  @override
  int get hashCode => Object.hash(id,email);

  /*
    Métod de creación a partir de un json que se obtiene a partir de una
    consulta a la API de rails, básicamente se crea un User asignando los
    atributos para tenerlo y utilizarlo en el frontend

    Se hará con el login y se obtendrá el User que esté activo, si se cierra
    sesión se eliminará ese y luego se podrá hacer inicio de sesión a otro

    En teoría no hace falta un toJson porque no he puesto edición de datos
    para los users, se puede meter luego
   */
  factory User.fromJson(Map<String,dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  /*
    Objetivo:
      Devolver los grupos de un usuario con todos los datos asociados

    Tener en cuenta:
      Al devolver los grupos se devuelve el grupo entero con sus datos
      luego es fácil tenerlos todos guardados en la interfaz (no tener que
      cargarlos cada vez) y cuando se entra en uno para ver los datos ya
      están los datos ahí. Eso se puede guardar en la interfaz teniendo un
      listado static de groups o algo así.
   */
  Future<List<Group>> getGroups() async{
    final token = await TokenService().getToken();
    if (token == null) return [];

    final url = Uri.parse('$apiUrl/$id/groups');
    final response = await http.get(url,
        headers: {'Authorization': token,
          'Content-Type': 'application/json'});

    final data = jsonDecode(response.body);
    if (response.statusCode == 200){
      List<Group> grupos = (data as List<dynamic>? ?? [])
          .map((groupJson) => Group.fromJson(groupJson as Map<String,dynamic>))
          .toList();
      return grupos;
    }
    else{
      final errors = data['error'];
      throw Exception("Error al obtener los grupos: $errors");
    }
  }


  /*
    Esta función recibe:
      groupName -> Nombre de grupo, tiene que ser único y no existir
    Objetivo:
      Crear un nuevo grupo en la base de datos con el user creador
      como único participante, el grupo no puede tener ni gastos ni
      nada, estar completamente vacío
   */
  Future<Group> createGroup(groupName) async{
    final token = await TokenService().getToken();
    if (token == null) throw  Exception("No hay sesion");

    final url = Uri.parse('$apiUrl/$id/groups');
    final response = await http.post(url,
      headers: {'Authorization': token,
                 'Content-Type': 'application/json'},
      body: jsonEncode({
        'group': {
          'group_name': groupName,
          'total_expense': 0,
          'balances': {
            '$username': 0,
          },
          'refunds': {
            '$username': {},
          },
        }
      }));

    final data = jsonDecode(response.body);
    if (response.statusCode == 201){
      return Group.fromJson(data);
    }
    else {
      final errors = data['error'];
      throw Exception('Error al crear el grupo: $errors');
    }
  }



  Future<void> deleteGroup(group_id) async {
    final token = await TokenService().getToken();
    if (token == null) throw  Exception("No hay sesion");

    final url = Uri.parse('$apiUrl/$id/groups/$group_id');
    final response = await http.delete(url,
        headers: {'Authorization': token,
        'Content-Type': 'application/json'});

    if (response.statusCode == 204){
      // BIEN
    }
    else{
      final data = jsonDecode(response.body);
      final errors = data['errors'];
      throw Exception("Error al eliminar el grupo: $errors");
    }
  }
}