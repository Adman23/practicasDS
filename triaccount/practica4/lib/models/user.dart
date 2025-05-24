
class User{
  int? id;
  String? username;
  String? email;
  String? phone;


  User({ this.id, this.username, this.email, this.phone});

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
    Esta función recibe:
      groupName -> Nombre de grupo, tiene que ser único y no existir
    Objetivo:
      Crear un nuevo grupo en la base de datos con el user creador
      como único participante, el grupo no puede tener ni gastos ni
      nada, estar completamente vacío
   */
  createGroup(groupName){

  }

  /*
    Esta función recibe:
      group -> String representando nombre del grupo
      user  -> String representando el nombre de usuario
    Objetivo:
      Asociar group con su id, hacer una instrucción de base de datos siempre
      que se cumplan las condiciones, de añadir el user (único) siempre que
      exista al grupo identificado por group
   */
  inviteUser(group, user){

  }
}