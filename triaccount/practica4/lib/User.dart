
class User{
  int? id;
  String? username;
  final String? email;
  final String? phone;


  User({required this.id, required this.username,
        required this.email, required this.phone});

  factory

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