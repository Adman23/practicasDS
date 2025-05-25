import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart'; // Asegúrate de que el archivo exista y esté en la ruta correcta

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(TricountApp());
}

class TricountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triaccount',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}
