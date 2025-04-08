import 'AdminFiltros.dart';
import 'Correo.dart';

class Cliente {
  final AdminFiltros admin;

  Cliente(this.admin);

  MapEntry<bool,String> enviarCorreo(String email, String password) {
    Correo correo = Correo(email, password);
    return admin.postCorreo(correo);
  }
}